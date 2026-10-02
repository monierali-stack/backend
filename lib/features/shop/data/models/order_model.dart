import 'package:shop/core/network/api_constants.dart';

enum OrderStatus { active, completed, cancelled }

OrderStatus _statusFromString(String? raw) {
  switch ((raw ?? '').toLowerCase()) {
    case 'completed':
    case 'complete':
    case 'delivered':
      return OrderStatus.completed;
    case 'cancelled':
    case 'canceled':
      return OrderStatus.cancelled;
    default:
      return OrderStatus.active;
  }
}

class OrderItemModel {
  final String productId;
  final String productName;
  final String? productImage;
  final double price;
  final int quantity;

  const OrderItemModel({
    required this.productId,
    required this.productName,
    this.productImage,
    required this.price,
    required this.quantity,
  });

  // TODO: confirm real field names for the order/items wrapper itself —
  // assuming each order item embeds a nested "product" object plus a
  // "quantity", based on how place_order is sent ({product_id, quantity}).
  // The nested product's own fields follow the same convention confirmed
  // on GET products (image_path, etc).
  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    final product = json['product'];
    if (product is Map) {
      return OrderItemModel(
        productId: (product['id'] ?? json['product_id']).toString(),
        productName: (product['name'] ?? '').toString(),
        productImage: ApiConstants.resolveImageUrl(product['image_path']?.toString()),
        price: double.tryParse((product['price'] ?? json['price'] ?? 0).toString()) ?? 0,
        quantity: int.tryParse((json['quantity'] ?? 1).toString()) ?? 1,
      );
    }
    return OrderItemModel(
      productId: (json['product_id'] ?? '').toString(),
      productName: (json['name'] ?? json['product_name'] ?? '').toString(),
      productImage: ApiConstants.resolveImageUrl(json['image_path']?.toString()),
      price: double.tryParse((json['price'] ?? 0).toString()) ?? 0,
      quantity: int.tryParse((json['quantity'] ?? 1).toString()) ?? 1,
    );
  }
}

class OrderModel {
  final String id;
  final DateTime placedAt;
  final OrderStatus status;
  final List<OrderItemModel> items;

  const OrderModel({
    required this.id,
    required this.placedAt,
    required this.status,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] ?? json['order_items'] ?? []) as List;
    return OrderModel(
      id: (json['id'] ?? json['order_id']).toString(),
      placedAt: DateTime.tryParse(
            (json['created_at'] ?? json['date'] ?? '').toString(),
          ) ??
          DateTime.now(),
      status: _statusFromString(json['status']?.toString()),
      items: rawItems
          .map((e) => OrderItemModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  double get subtotal => items.fold(0, (sum, i) => sum + i.price * i.quantity);
  int get itemCount => items.fold(0, (sum, i) => sum + i.quantity);
}
