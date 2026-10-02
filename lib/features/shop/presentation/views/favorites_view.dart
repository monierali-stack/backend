import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/core/helper/my_navigator.dart';
import 'package:shop/core/utils/app_colors.dart';
import 'package:shop/features/shop/presentation/cubit/main/main_cubit.dart';
import 'package:shop/features/shop/presentation/cubit/main/main_state.dart';
import 'package:shop/features/shop/presentation/views/product_details_view.dart';
import 'package:shop/features/shop/presentation/views/widgets/product_card.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        var cubit = MainCubit.get(context);
        var favorites = cubit.favoriteProducts;
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
                        icon: Icon(Icons.arrow_back_ios_new, color: AppColors.black, size: 20),
                      ),
                      Text(
                        'My Favorites',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: favorites.isEmpty
                        ? Center(
                            child: Text(
                              'No favorites yet',
                              style: TextStyle(color: AppColors.darkGery, fontSize: 14),
                            ),
                          )
                        : GridView.builder(
                            itemCount: favorites.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 0.54,
                            ),
                            itemBuilder: (context, index) {
                              var product = favorites[index];
                              return ProductCard(
                                product: product,
                                isFavorite: true,
                                onFavoriteTap: () => cubit.toggleFavorite(product.id),
                                onTap: () =>
                                    goTo(context, toPage: ProductDetailsView(product: product)),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
