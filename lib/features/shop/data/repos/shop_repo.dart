import 'package:dio/dio.dart';
import 'package:shop/core/network/api_constants.dart';
import 'package:shop/core/network/dio_helper.dart';
import 'package:shop/features/shop/data/models/category_model.dart';
import 'package:shop/features/shop/data/models/order_model.dart';
import 'package:shop/features/shop/data/models/product_model.dart';
import 'package:shop/features/shop/data/models/slider_model.dart';

class ShopRepo {
  // TODO: confirm the real wrapper key for list responses — this tries
  // a few common ones ("products"/"data"/"items"/"result") before
  // falling back to "the response body is the list itself".
  static List _extractList(dynamic data, List<String> possibleKeys) {
    if (data is List) return data;
    if (data is Map) {
      for (final key in possibleKeys) {
        if (data[key] is List) return data[key] as List;
      }
    }
    return [];
  }

  static Future<List<CategoryModel>> getCategories() async {
    final response = await DioHelper.get(ApiConstants.categories);
    final list = _extractList(response.data, ['categories', 'data', 'result']);
    return list
        .map((e) => CategoryModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  static Future<List<SliderModel>> getSliders() async {
    final response = await DioHelper.get(ApiConstants.sliders);
    final list = _extractList(response.data, ['sliders', 'data', 'result']);
    return list.map((e) => SliderModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  static Future<List<ProductModel>> getProducts() async {
    final response = await DioHelper.get(ApiConstants.products);
    final list = _extractList(response.data, ['products', 'data', 'result']);
    return list.map((e) => ProductModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  static Future<List<ProductModel>> searchProducts(String query) async {
    final response =
        await DioHelper.get(ApiConstants.searchProducts, query: {'q': query});
    final list = _extractList(response.data, ['products', 'data', 'result']);
    return list.map((e) => ProductModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  static Future<List<ProductModel>> getBestSellers() async {
    final response = await DioHelper.get(ApiConstants.bestSellerProducts);
    final list = _extractList(response.data, ['products', 'data', 'result']);
    return list.map((e) => ProductModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  static Future<List<ProductModel>> getTopRated() async {
    final response = await DioHelper.get(ApiConstants.topRatedProducts);
    final list = _extractList(response.data, ['products', 'data', 'result']);
    return list.map((e) => ProductModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  // No dedicated "list my favorites" endpoint exists in the collection —
  // only add_to_favorite. Assuming it TOGGLES (adds if absent, removes
  // if already favorited), since there's no separate remove endpoint.
  static Future<void> toggleFavorite(String productId) async {
    await DioHelper.post(
      ApiConstants.addToFavorite,
      formData: FormData.fromMap({'product_id': productId}),
    );
  }

  static Future<void> placeOrder(Map<String, int> cart) async {
    await DioHelper.post(
      ApiConstants.placeOrder,
      data: {
        'items': cart.entries
            .map((e) => {'product_id': int.tryParse(e.key) ?? e.key, 'quantity': e.value})
            .toList(),
      },
    );
  }

  static Future<void> cancelOrder(String orderId) async {
    await DioHelper.post(ApiConstants.cancelOrder(orderId));
  }

  static Future<List<OrderModel>> getOrders() async {
    final response = await DioHelper.get(ApiConstants.orders);
    final list = _extractList(response.data, ['orders', 'data', 'result']);
    return list.map((e) => OrderModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }
}
