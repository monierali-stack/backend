import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/core/helper/my_navigator.dart';
import 'package:shop/core/utils/app_assets.dart';
import 'package:shop/core/utils/app_colors.dart';
import 'package:shop/features/auth/data/repos/auth_repo.dart';
import 'package:shop/features/auth/presentation/views/get_started_view.dart';
import 'package:shop/features/shop/presentation/cubit/main/main_cubit.dart';
import 'package:shop/features/shop/presentation/cubit/main/main_state.dart';
import 'package:shop/features/shop/presentation/views/favorites_view.dart';
import 'package:shop/features/shop/presentation/views/my_profile_view.dart';
import 'package:shop/features/shop/presentation/views/orders_view.dart';
import 'package:shop/features/shop/presentation/views/settings_view.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        var cubit = MainCubit.get(context);
        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            children: [
              Text(
                'Profile',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.fieldFill,
                      backgroundImage: AssetImage(AppImages.avatarDefault),
                    ),
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Image.asset(AppImages.badgeOnline, width: 16, height: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: GestureDetector(
                  onTap: () => goTo(context, toPage: const MyProfileView()),
                  child: Text(
                    cubit.userFullName,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              _MenuItem(
                icon: Icons.person_outline,
                label: 'My Profile',
                onTap: () => goTo(context, toPage: const MyProfileView()),
              ),
              _MenuItem(
                icon: Icons.shopping_bag_outlined,
                label: 'My Orders',
                onTap: () => goTo(context, toPage: const OrdersView()),
              ),
              _MenuItem(
                icon: Icons.favorite_border,
                label: 'My Favorites',
                onTap: () => goTo(context, toPage: const FavoritesView()),
              ),
              _MenuItem(
                icon: Icons.settings_outlined,
                label: 'Settings',
                onTap: () => goTo(context, toPage: const SettingsView()),
              ),
              const SizedBox(height: 16),
              Divider(color: AppColors.inactiveDot),
              const SizedBox(height: 8),
              _MenuItem(
                icon: Icons.logout,
                label: 'Log Out',
                showChevron: false,
                onTap: () async {
                  await AuthRepo.logout();
                  if (context.mounted) {
                    goTo(context,
                        toPage: const GetStartedView(), type: NavigatorType.remove);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.showChevron = true,
  });

  final IconData icon;
  final String label;
  final void Function() onTap;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: AppColors.black, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (showChevron)
              Icon(Icons.chevron_right, color: AppColors.darkGery, size: 20),
          ],
        ),
      ),
    );
  }
}
