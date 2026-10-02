import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/core/network/api_error_helper.dart';
import 'package:shop/features/shop/data/models/category_model.dart';
import 'package:shop/features/shop/data/models/order_model.dart';
import 'package:shop/features/shop/data/models/product_model.dart';
import 'package:shop/features/shop/data/models/slider_model.dart';
import 'package:shop/features/shop/data/repos/shop_repo.dart';
import 'package:shop/features/shop/presentation/cubit/main/main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitState());

  static MainCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  String userFullName = 'User full Name';
  String userPhone = '';
  // Visual-only for now — no localization is wired up yet.
  String language = 'EN';

  void setLanguage(String lang) {
    language = lang;
    emit(MainNavChangedState());
  }

  void updateProfile({required String fullName, required String phone}) {
    userFullName = fullName.trim().isEmpty ? 'User full Name' : fullName.trim();
    userPhone = phone.trim();
    emit(MainNavChangedState());
  }

  // ---- Home data (categories / products / sliders) from the API ----

  List<CategoryModel> categories = [];
  List<SliderModel> sliders = [];
  List<ProductModel> products = [];
  bool isLoadingHome = false;
  String? homeError;

  Future<void> loadHomeData() async {
    isLoadingHome = true;
    homeError = null;
    emit(MainHomeDataLoadingState());
    try {
      final results = await Future.wait([
        ShopRepo.getCategories(),
        ShopRepo.getProducts(),
        ShopRepo.getSliders(),
      ]);
      final fetchedCategories = results[0] as List<CategoryModel>;
      // The last 4 categories on the server are junk/test entries
      // (duplicate "cat 1" placeholders, "Snacks", etc.) — trimmed
      // from display. Remove this once the backend data is cleaned up.
      categories = fetchedCategories.length > 4
          ? fetchedCategories.sublist(0, fetchedCategories.length - 4)
          : fetchedCategories;
      products = results[1] as List<ProductModel>;
      sliders = results[2] as List<SliderModel>;
      // Seed local favorite tracking from whatever the API told us,
      // since there's no separate "get my favorites" endpoint.
      favoriteIds
        ..clear()
        ..addAll(products.where((p) => p.isFavorite).map((p) => p.id));
      isLoadingHome = false;
      emit(MainHomeDataLoadedState());
    } catch (e) {
      isLoadingHome = false;
      homeError = ApiErrorHelper.messageFrom(e);
      emit(MainHomeDataErrorState(homeError!));
    }
  }

  List<ProductModel> productsInCategory(String categoryId) =>
      products.where((p) => p.categoryId == categoryId).toList();

  void changeTab(int index) {
    currentIndex = index;
    emit(MainNavChangedState());
  }

  // ---- Favorites ----
  // No "list favorites" or explicit "remove favorite" endpoint exists —
  // add_to_favorite is assumed to toggle. Tracked locally so the UI
  // stays responsive even if that assumption is slightly off.

  final Set<String> favoriteIds = {};

  bool isFavorite(String productId) => favoriteIds.contains(productId);

  void seedFavorites(List<String> ids) {
    favoriteIds
      ..clear()
      ..addAll(ids);
    emit(MainFavoriteToggledState());
  }

  Future<void> toggleFavorite(String productId) async {
    final wasFavorite = favoriteIds.contains(productId);
    if (wasFavorite) {
      favoriteIds.remove(productId);
    } else {
      favoriteIds.add(productId);
    }
    emit(MainFavoriteToggledState());
    try {
      await ShopRepo.toggleFavorite(productId);
    } catch (_) {
      // Revert on failure.
      if (wasFavorite) {
        favoriteIds.add(productId);
      } else {
        favoriteIds.remove(productId);
      }
      emit(MainFavoriteToggledState());
    }
  }

  List<ProductModel> get favoriteProducts =>
      products.where((p) => favoriteIds.contains(p.id)).toList();

  // ---- Cart ----
  // No cart endpoint exists in the API — cart stays entirely local
  // and is only sent to the server as a whole via place_order.

  final Map<String, int> cart = {};

  static const double taxAndFees = 3;
  static const double deliveryFee = 2;

  bool isInCart(String productId) => cart.containsKey(productId);

  void addToCart(String productId, {int quantity = 1}) {
    cart[productId] = (cart[productId] ?? 0) + quantity;
    emit(MainCartChangedState());
  }

  void incrementCartItem(String productId) {
    cart[productId] = (cart[productId] ?? 0) + 1;
    emit(MainCartChangedState());
  }

  void decrementCartItem(String productId) {
    final current = cart[productId] ?? 0;
    if (current <= 1) {
      cart.remove(productId);
    } else {
      cart[productId] = current - 1;
    }
    emit(MainCartChangedState());
  }

  void clearCart() {
    cart.clear();
    emit(MainCartChangedState());
  }

  List<ProductModel> get cartProducts =>
      products.where((p) => cart.containsKey(p.id)).toList();

  int get cartItemCount => cart.length;

  double get subtotal {
    double total = 0;
    for (final entry in cart.entries) {
      final product = products.firstWhere(
        (p) => p.id == entry.key,
        orElse: () => ProductModel(id: entry.key, name: '', description: '', price: 0, rating: 0),
      );
      total += product.price * entry.value;
    }
    return total;
  }

  double get orderTotal => subtotal == 0 ? 0 : subtotal + taxAndFees + deliveryFee;

  // ---- Orders ----

  List<OrderModel> orders = [];
  bool isLoadingOrders = false;
  String? ordersError;

  Future<void> loadOrders() async {
    isLoadingOrders = true;
    emit(MainOrdersLoadingState());
    try {
      orders = await ShopRepo.getOrders();
      isLoadingOrders = false;
      emit(MainOrdersUpdatedState());
    } catch (e) {
      isLoadingOrders = false;
      ordersError = ApiErrorHelper.messageFrom(e);
      emit(MainOrdersErrorState(ordersError!));
    }
  }

  Future<bool> placeOrder() async {
    if (cart.isEmpty) return false;
    try {
      await ShopRepo.placeOrder(cart);
      cart.clear();
      emit(MainCartChangedState());
      await loadOrders();
      return true;
    } catch (e) {
      emit(MainOrdersErrorState(ApiErrorHelper.messageFrom(e)));
      return false;
    }
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      await ShopRepo.cancelOrder(orderId);
      await loadOrders();
    } catch (e) {
      emit(MainOrdersErrorState(ApiErrorHelper.messageFrom(e)));
    }
  }

  List<OrderModel> ordersByStatus(OrderStatus status) =>
      orders.where((o) => o.status == status).toList();
}
