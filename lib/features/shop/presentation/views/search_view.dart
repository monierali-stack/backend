import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/core/helper/my_navigator.dart';
import 'package:shop/core/utils/app_colors.dart';
import 'package:shop/features/shop/presentation/cubit/main/main_cubit.dart';
import 'package:shop/features/shop/presentation/cubit/main/main_state.dart';
import 'package:shop/features/shop/presentation/cubit/search/search_cubit.dart';
import 'package:shop/features/shop/presentation/cubit/search/search_state.dart';
import 'package:shop/features/shop/presentation/views/product_details_view.dart';
import 'package:shop/features/shop/presentation/views/widgets/product_card.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocBuilder<MainCubit, MainState>(
        builder: (context, mainState) {
          var mainCubit = MainCubit.get(context);
          return BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              var cubit = SearchCubit.get(context);
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
                            Text(
                              'Search',
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: cubit.searchController,
                          autofocus: true,
                          onChanged: cubit.search,
                          style: TextStyle(fontSize: 14, color: AppColors.black),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.fieldFill,
                            hintText: 'Search any Product...',
                            hintStyle: TextStyle(color: AppColors.darkGery, fontSize: 14),
                            prefixIcon: Icon(Icons.search, color: AppColors.darkGery),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (cubit.searchController.text.isNotEmpty)
                          Text(
                            '${cubit.results.length} Items',
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        const SizedBox(height: 14),
                        Expanded(
                          child: cubit.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : cubit.error != null
                                  ? Center(
                                      child: Text(
                                        cubit.error!,
                                        textAlign: TextAlign.center,
                                        style:
                                            TextStyle(color: AppColors.darkGery, fontSize: 13),
                                      ),
                                    )
                                  : cubit.results.isEmpty
                                      ? Center(
                                          child: Text(
                                            cubit.searchController.text.isEmpty
                                                ? 'Start typing to search products'
                                                : 'No products found',
                                            style: TextStyle(
                                                color: AppColors.darkGery, fontSize: 13),
                                          ),
                                        )
                                      : GridView.builder(
                                          itemCount: cubit.results.length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            mainAxisSpacing: 16,
                                            crossAxisSpacing: 16,
                                            childAspectRatio: 0.54,
                                          ),
                                          itemBuilder: (context, index) {
                                            var product = cubit.results[index];
                                            return ProductCard(
                                              product: product,
                                              isFavorite: mainCubit.isFavorite(product.id),
                                              onFavoriteTap: () =>
                                                  mainCubit.toggleFavorite(product.id),
                                              onTap: () => goTo(context,
                                                  toPage:
                                                      ProductDetailsView(product: product)),
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
        },
      ),
    );
  }
}
