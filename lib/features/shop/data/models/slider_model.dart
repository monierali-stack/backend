import 'package:shop/core/network/api_constants.dart';

class SliderModel {
  final String id;
  final String title;
  final String description;
  final String? image;

  const SliderModel({
    required this.id,
    required this.title,
    required this.description,
    this.image,
  });

  // Following the same "image_path" convention confirmed on
  // products/categories/user.
  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      id: (json['id'] ?? json['slider_id']).toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      image: ApiConstants.resolveImageUrl(json['image_path']?.toString()),
    );
  }
}
