import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/core/components/default_btn.dart';
import 'package:shop/core/helper/my_navigator.dart';
import 'package:shop/core/utils/app_colors.dart';
import 'package:shop/features/shop/presentation/cubit/checkout/checkout_cubit.dart';
import 'package:shop/features/shop/presentation/cubit/checkout/checkout_state.dart';
import 'package:shop/features/shop/presentation/cubit/main/main_cubit.dart';
import 'package:shop/features/shop/presentation/views/main_view.dart';
import 'package:shop/features/shop/presentation/views/widgets/cart_product_row.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckoutCubit(),
      child: BlocConsumer<CheckoutCubit, CheckoutState>(
        listener: (context, state) {
          if (state is CheckoutOrderPlacedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Order placed successfully 🎉'),
                backgroundColor: AppColors.primary,
                behavior: SnackBarBehavior.floating,
              ),
            );
            goTo(context, toPage: const MainView(), type: NavigatorType.remove);
          } else if (state is CheckoutErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          var cubit = CheckoutCubit.get(context);
          var mainCubit = MainCubit.get(context);
          var cartProducts = mainCubit.cartProducts;
          return Scaffold(
            backgroundColor: AppColors.scaffoldBackground,
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.arrow_back_ios_new,
                              color: AppColors.black, size: 20),
                        ),
                        Expanded(
                          child: Text(
                            'Checkout',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 40),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 18, color: AppColors.black),
                            const SizedBox(width: 6),
                            Text(
                              'Delivery Address',
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.fieldFill,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: TextField(
                                  controller: cubit.addressController,
                                  maxLines: 2,
                                  style: TextStyle(fontSize: 13, color: AppColors.black),
                                  decoration: InputDecoration(
                                    isCollapsed: true,
                                    border: InputBorder.none,
                                    hintText: 'Type address here\nor pick from map',
                                    hintStyle: TextStyle(color: AppColors.darkGery, fontSize: 13),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 52,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.location_on, color: AppColors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Shopping List',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        for (final product in cartProducts)
                          CartProductRow(
                            name: product.name,
                            image: product.image,
                            price: product.price,
                            originalPrice: product.originalPrice,
                            rating: product.rating,
                            quantity: mainCubit.cart[product.id] ?? 1,
                            editable: false,
                          ),
                        const SizedBox(height: 8),
                        _SummaryRow(label: 'Subtotal', value: mainCubit.subtotal),
                        _SummaryRow(label: 'Tax and Fees', value: MainCubit.taxAndFees),
                        _SummaryRow(label: 'Delivery Fee', value: MainCubit.deliveryFee),
                        const SizedBox(height: 8),
                        Divider(color: AppColors.inactiveDot),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order Total',
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$${mainCubit.orderTotal.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: DefaultBtn(
                      text: 'Place Order',
                      onTap: () => cubit.placeOrder(mainCubit),
                      loading: state is CheckoutLoadingState,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppColors.darkGery, fontSize: 13)),
          Text(
            '\$${value.toStringAsFixed(2)}',
            style: TextStyle(color: AppColors.black, fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
