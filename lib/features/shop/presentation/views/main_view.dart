import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/core/helper/my_navigator.dart';
import 'package:shop/core/utils/app_assets.dart';
import 'package:shop/core/utils/app_colors.dart';
import 'package:shop/features/shop/presentation/cubit/main/main_cubit.dart';
import 'package:shop/features/shop/presentation/cubit/main/main_state.dart';
import 'package:shop/features/shop/presentation/views/cart_view.dart';
import 'package:shop/features/shop/presentation/views/home_tab.dart';
import 'package:shop/features/shop/presentation/views/items_tab.dart';
import 'package:shop/features/shop/presentation/views/profile_tab.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  static const _tabs = [HomeTab(), ItemsTab(), ProfileTab()];

  @override
  void initState() {
    super.initState();
    MainCubit.get(context).loadHomeData();
  }

  @override
  Widget build(BuildContext context) {
    // MainCubit is provided app-wide in main.dart, so it stays reachable
    // from pages pushed on top of this shell (e.g. ProductDetailsView).
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        var cubit = MainCubit.get(context);
        return Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          body: IndexedStack(index: cubit.currentIndex, children: _tabs),
          // Matches the floating "bag" badge shown bottom-right on the
          // Home and Trending Products screens in the Figma file — it's
          // a shortcut into the Cart, not tied to any single product card.
          floatingActionButton: cubit.currentIndex == 2
              ? null
              : Stack(
                  clipBehavior: Clip.none,
                  children: [
                    FloatingActionButton(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      onPressed: () => goTo(context, toPage: const CartView()),
                      child: Image.asset(AppImages.badgeBag, width: 56, height: 56),
                    ),
                    if (cubit.cartItemCount > 0)
                      Positioned(
                        top: -2,
                        right: -2,
                        child: CircleAvatar(
                          radius: 9,
                          backgroundColor: AppColors.black,
                          child: Text(
                            '${cubit.cartItemCount}',
                            style: TextStyle(color: AppColors.white, fontSize: 10),
                          ),
                        ),
                      ),
                  ],
                ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: cubit.changeTab,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.darkGery,
            showUnselectedLabels: true,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_outlined),
                label: 'Items',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
            ],
          ),
        );
      },
    );
  }
}
