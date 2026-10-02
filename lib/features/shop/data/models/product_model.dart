import 'package:shop/core/network/api_constants.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  // Original (pre-discount) price — the API doesn't return this, so
  // it stays null; the UI already hides it when null.
  final double? originalPrice;
  final double rating;
  final int? ratingCount;
  final String? image;
  final String? categoryId;
  final String? categoryTitle;
  final bool bestSeller;
  final bool isFavorite;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.rating,
    this.ratingCount,
    this.image,
    this.categoryId,
    this.categoryTitle,
    this.bestSeller = false,
    this.isFavorite = false,
  });

  // CONFIRMED from a real GET products response:
  // {"products": [{"id":.., "name":.., "description":.., "price":..,
  //   "image_path": "https://res.cloudinary.com/...",
  //   "is_favorite": false, "best_seller": 1,
  //   "category": {"id":.., "title":.., "image_path":..}, ...}]}
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final category = json['category'];
    return ProductModel(
      id: (json['id'] ?? json['product_id']).toString(),
      name: (json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      price: double.tryParse(json['price'].toString()) ?? 0,
      rating: double.tryParse((json['rating'] ?? 0).toString()) ?? 0,
      image: ApiConstants.resolveImageUrl(json['image_path']?.toString()),
      categoryId: category is Map
          ? category['id']?.toString()
          : json['category_id']?.toString(),
      categoryTitle: category is Map ? category['title']?.toString() : null,
      bestSeller: json['best_seller'] == true ||
          json['best_seller'] == 1 ||
          json['best_seller'] == '1',
      isFavorite: json['is_favorite'] == true || json['is_favorite'] == 1,
    );
  }
}
