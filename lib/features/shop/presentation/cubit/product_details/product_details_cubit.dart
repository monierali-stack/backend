import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/features/shop/presentation/cubit/product_details/product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(ProductDetailsInitState());

  static ProductDetailsCubit get(context) => BlocProvider.of(context);

  int quantity = 1;

  void increment() {
    quantity++;
    emit(ProductDetailsQuantityChangedState());
  }

  void decrement() {
    if (quantity > 1) {
      quantity--;
      emit(ProductDetailsQuantityChangedState());
    }
  }

  // TODO: wire this up to a real cart/API once one exists.
  void addToCart() {
    emit(ProductDetailsAddedToCartState());
  }
}
