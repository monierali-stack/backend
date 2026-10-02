import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/core/helper/my_navigator.dart';
import 'package:shop/core/utils/app_assets.dart';
import 'package:shop/core/utils/app_colors.dart';
import 'package:shop/features/shop/presentation/cubit/main/main_cubit.dart';
import 'package:shop/features/shop/presentation/cubit/main/main_state.dart';
import 'package:shop/features/shop/presentation/views/favorites_view.dart';
import 'package:shop/features/shop/presentation/views/product_details_view.dart';
import 'package:shop/features/shop/presentation/views/widgets/category_avatar.dart';
import 'package:shop/features/shop/presentation/views/widgets/product_card.dart';

class ItemsTab extends StatelessWidget {
  const ItemsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        var cubit = MainCubit.get(context);
        return SafeArea(
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: cubit.loadHomeData,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => goTo(context, toPage: const FavoritesView()),
                      icon: Icon(Icons.favorite_border, color: AppColors.black),
                    ),
                    Image.asset(
                      AppImages.logo,
                      height: 30,
                      errorBuilder: (context, error, stackTrace) => Text(
                        'Stylish',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 20),
                if (cubit.isLoadingHome)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (cubit.homeError != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        Icon(Icons.wifi_off_rounded, size: 40, color: AppColors.darkGery),
                        const SizedBox(height: 12),
                        Text(
                          cubit.homeError!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.darkGery, fontSize: 13),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: cubit.loadHomeData,
                          child: Text('Retry', style: TextStyle(color: AppColors.primary)),
                        ),
                      ],
                    ),
                  )
                else ...[
                  Text(
                    'All Featured',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 92,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: cubit.categories.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 16),
                      itemBuilder: (context, index) =>
                          CategoryAvatar(category: cubit.categories[index]),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Products',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 14),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cubit.products.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.54,
                    ),
                    itemBuilder: (context, index) {
                      var product = cubit.products[index];
                      return ProductCard(
                        product: product,
                        isFavorite: cubit.isFavorite(product.id),
                        onFavoriteTap: () => cubit.toggleFavorite(product.id),
                        onTap: () =>
                            goTo(context, toPage: ProductDetailsView(product: product)),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
