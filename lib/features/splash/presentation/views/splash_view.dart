import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/core/helper/my_navigator.dart';
import 'package:shop/core/utils/app_assets.dart';
import 'package:shop/core/utils/app_colors.dart';
import 'package:shop/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:shop/features/splash/presentation/cubit/splash/splash_cubit.dart';
import 'package:shop/features/splash/presentation/cubit/splash/splash_state.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..startTimer(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is SplashNavigateState) {
            goTo(
              context,
              toPage: const OnboardingView(),
              type: NavigatorType.replace,
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          body: Center(
            child: Image.asset(
              AppImages.logo,
              width: 220,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Text(
                'Stylish',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
