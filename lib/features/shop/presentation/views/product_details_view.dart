import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/core/components/default_btn.dart';
import 'package:shop/core/components/network_or_placeholder.dart';
import 'package:shop/core/utils/app_colors.dart';
import 'package:shop/features/shop/data/models/product_model.dart';
import 'package:shop/features/shop/presentation/cubit/main/main_cubit.dart';
import 'package:shop/features/shop/presentation/cubit/main/main_state.dart';
import 'package:shop/features/shop/presentation/cubit/product_details/product_details_cubit.dart';
import 'package:shop/features/shop/presentation/cubit/product_details/product_details_state.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductDetailsCubit(),
      child: BlocConsumer<ProductDetailsCubit, ProductDetailsState>(
        listener: (context, state) {
          if (state is ProductDetailsAddedToCartState) {
            MainCubit.get(context).addToCart(
              product.id,
              quantity: ProductDetailsCubit.get(context).quantity,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Added to cart'),
                backgroundColor: AppColors.primary,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 1),
              ),
            );
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          var cubit = ProductDetailsCubit.get(context);
          return BlocBuilder<MainCubit, MainState>(
            builder: (context, mainState) {
              var mainCubit = MainCubit.get(context);
              return Scaffold(
                backgroundColor: AppColors.scaffoldBackground,
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.arrow_back_ios_new,
                                  color: AppColors.black, size: 20),
                            ),
                            Expanded(
                              child: Text(
                                'Product',
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
                        const SizedBox(height: 8),
                        Expanded(
                          child: ListView(
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: Container(
                                      width: double.infinity,
                                      color: AppColors.fieldFill,
                                      padding: const EdgeInsets.symmetric(vertical: 24),
                                      child: NetworkOrPlaceholder(
                                        url: product.image,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: GestureDetector(
                                      onTap: () => mainCubit.toggleFavorite(product.id),
                                      child: CircleAvatar(
                                        radius: 18,
                                        backgroundColor: AppColors.white,
                                        child: Icon(
                                          mainCubit.isFavorite(product.id)
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                product.name,
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                product.description,
                                style: TextStyle(
                                  color: AppColors.darkGery,
                                  fontSize: 13,
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\$${product.price.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      _StepperButton(
                                        icon: Icons.remove,
                                        onTap: cubit.decrement,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        child: Text(
                                          '${cubit.quantity}',
                                          style: TextStyle(
                                            color: AppColors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      _StepperButton(
                                        icon: Icons.add,
                                        onTap: cubit.increment,
                                        filled: true,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 28),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: DefaultBtn(
                            text: 'Add To Cart',
                            onTap: cubit.addToCart,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onTap, this.filled = false});

  final IconData icon;
  final void Function() onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 28,
        width: 28,
        decoration: BoxDecoration(
          color: filled ? AppColors.primary : AppColors.fieldFill,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 16,
          color: filled ? AppColors.white : AppColors.black,
        ),
      ),
    );
  }
}
