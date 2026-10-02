import 'package:flutter/material.dart';
import 'package:shop/core/components/default_btn.dart';
import 'package:shop/core/helper/my_navigator.dart';
import 'package:shop/core/utils/app_assets.dart';
import 'package:shop/core/utils/app_colors.dart';
import 'package:shop/features/auth/presentation/views/login_view.dart';
import 'package:shop/features/auth/presentation/views/register_view.dart';

class GetStartedView extends StatelessWidget {
  const GetStartedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppImages.getStartedBg,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.black, AppColors.primary.withValues(alpha: 0.6)],
                ),
              ),
            ),
          ),
          // Darkening gradient so the white text/buttons stay readable
          // over the photo, same as the Figma design.
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.4, 1],
                colors: [Colors.transparent, Colors.black.withValues(alpha: 0.75)],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'You want Authentic, here you go!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Find it here, buy it now!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.white.withValues(alpha: 0.85),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 28),
                  DefaultBtn(
                    text: 'Login',
                    onTap: () => goTo(context, toPage: const LoginView()),
                  ),
                  const SizedBox(height: 14),
                  DefaultBtn(
                    text: 'Register',
                    outlined: true,
                    onTap: () => goTo(context, toPage: const RegisterView()),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
