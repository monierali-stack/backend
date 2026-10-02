import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/core/components/default_btn.dart';
import 'package:shop/core/helper/my_navigator.dart';
import 'package:shop/core/utils/app_colors.dart';
import 'package:shop/features/shop/presentation/cubit/main/main_cubit.dart';
import 'package:shop/features/shop/presentation/cubit/main/main_state.dart';
import 'package:shop/features/shop/presentation/views/checkout_view.dart';
import 'package:shop/features/shop/presentation/views/widgets/cart_product_row.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        var cubit = MainCubit.get(context);
        var cartProducts = cubit.cartProducts;
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
                        icon: Icon(Icons.arrow_back_ios_new, color: AppColors.black, size: 20),
                      ),
                      Expanded(
                        child: Text(
                          'Cart',
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
                  child: cartProducts.isEmpty
                      ? Center(
                          child: Text(
                            'Your cart is empty',
                            style: TextStyle(color: AppColors.darkGery, fontSize: 14),
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          children: [
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
                                quantity: cubit.cart[product.id] ?? 1,
                                onIncrement: () => cubit.incrementCartItem(product.id),
                                onDecrement: () => cubit.decrementCartItem(product.id),
                              ),
                          ],
                        ),
                ),
                if (cartProducts.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: DefaultBtn(
                      text: 'Checkout',
                      onTap: () => goTo(context, toPage: const CheckoutView()),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
