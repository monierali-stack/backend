import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/features/shop/presentation/cubit/checkout/checkout_state.dart';
import 'package:shop/features/shop/presentation/cubit/main/main_cubit.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutInitState());

  static CheckoutCubit get(context) => BlocProvider.of(context);

  final addressController = TextEditingController();

  Future<void> placeOrder(MainCubit mainCubit) async {
    emit(CheckoutLoadingState());
    final success = await mainCubit.placeOrder();
    if (success) {
      emit(CheckoutOrderPlacedState());
    } else {
      emit(CheckoutErrorState(mainCubit.ordersError ?? 'Could not place the order.'));
    }
  }

  @override
  Future<void> close() {
    addressController.dispose();
    return super.close();
  }
}
