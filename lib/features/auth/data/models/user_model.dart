class UserModel {
  final String? id;
  final String name;
  final String email;
  final String phone;
  final String? image;
  // Product IDs the user has favorited, as reported by get_user_data.
  final List<String> favoriteProductIds;

  const UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.image,
    this.favoriteProductIds = const [],
  });

  // CONFIRMED from a real get_user_data response:
  // {"status": true, "user": {"id":.., "name":.., "email":..,
  //  "phone":.., "image_path": null, "favorite_products": [...]}}
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final rawFavorites = json['favorite_products'];
    final favoriteIds = <String>[];
    if (rawFavorites is List) {
      for (final f in rawFavorites) {
        if (f is Map) {
          final id = f['id'] ?? f['product_id'];
          if (id != null) favoriteIds.add(id.toString());
        } else {
          favoriteIds.add(f.toString());
        }
      }
    }
    return UserModel(
      id: json['id']?.toString(),
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      image: json['image_path']?.toString(),
      favoriteProductIds: favoriteIds,
    );
  }
}
