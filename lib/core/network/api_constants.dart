abstract class ApiConstants {
  static const String baseUrl =
      'https://nti-ecommerce-api-production-0f69.up.railway.app/api/';
  static const String serverRoot =
      'https://nti-ecommerce-api-production-0f69.up.railway.app/';

  // TODO: confirm how the API returns image paths — this assumes it's
  // either a full URL already, or a path relative to the server root
  // (not under /api/). Adjust the prefix here if uploads are served
  // from a different path (e.g. "/storage/", "/uploads/").
  static String? resolveImageUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return '$serverRoot$cleanPath';
  }

  // users
  static const String register = 'register';
  static const String login = 'login';
  static const String refreshToken = 'refresh_token';
  static const String updateProfile = 'update_profile';
  static const String getUserData = 'get_user_data';
  static const String deleteUser = 'delete_user';

  // sliders
  static const String sliders = 'sliders';

  // categories
  static const String categories = 'categories';

  // orders
  static const String placeOrder = 'place_order';
  static String cancelOrder(dynamic id) => 'orders/cancel/$id';
  static String completeOrder(dynamic id) => 'orders/complete/$id';
  static const String orders = 'orders';

  // products
  static const String products = 'products';
  static const String addToFavorite = 'add_to_favorite';
  static const String searchProducts = 'products/search';
  static const String bestSellerProducts = 'best_seller_products';
  static const String topRatedProducts = 'top_rated_products';
}
