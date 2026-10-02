import 'package:shop/core/network/api_constants.dart';

class CategoryModel {
  final String id;
  final String name;
  final String? image;

  const CategoryModel({required this.id, required this.name, this.image});

  // CONFIRMED from the nested "category" object in a real products
  // response: {"id":.., "title":.., "description":..,
  // "image_path": "https://res.cloudinary.com/..."}
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: (json['id'] ?? json['category_id']).toString(),
      name: (json['title'] ?? json['name'] ?? '').toString(),
      image: ApiConstants.resolveImageUrl(json['image_path']?.toString()),
    );
  }
}
