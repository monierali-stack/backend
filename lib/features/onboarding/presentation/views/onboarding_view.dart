import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/core/helper/my_navigator.dart';
import 'package:shop/core/utils/app_colors.dart';
import 'package:shop/features/auth/presentation/views/get_started_view.dart';
import 'package:shop/features/onboarding/data/models/onboard_model.dart';
import 'package:shop/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:shop/features/onboarding/presentation/cubit/onboarding_state.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(),
      child: BlocConsumer<OnboardingCubit, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingFinishedState) {
            goTo(context, toPage: const GetStartedView(), type: NavigatorType.replace);
          }
        },
        builder: (context, state) {
          var cubit = OnboardingCubit.get(context);
          return Scaffold(
            backgroundColor: AppColors.scaffoldBackground,
            body: SafeArea(
              child: Column(
                children: [
                  // Skip is hidden entirely on the last slide, per the design.
                  SizedBox(
                    height: 48,
                    child: cubit.isLastPage
                        ? null
                        : Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 24, top: 8),
                              child: TextButton(
                                onPressed: cubit.skip,
                                child: Text(
                                  'Skip',
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: cubit.pageController,
                      onPageChanged: cubit.onPageChanged,
                      itemCount: onboardData.length,
                      itemBuilder: (context, index) {
                        return _OnboardPage(data: onboardData[index]);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Row(
                      children: [
                        // Prev is hidden entirely on the first slide, per the design.
                        SizedBox(
                          width: 44,
                          child: cubit.currentIndex == 0
                              ? null
                              : TextButton(
                                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                  onPressed: cubit.prev,
                                  child: Text(
                                    'Prev',
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                        ),
                        const Spacer(),
                        Row(
                          children: List.generate(
                            onboardData.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              height: 8,
                              width: cubit.currentIndex == index ? 22 : 8,
                              decoration: BoxDecoration(
                                color: cubit.currentIndex == index
                                    ? AppColors.black
                                    : AppColors.inactiveDot,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: cubit.next,
                          child: Text(
                            cubit.isLastPage ? 'Get Started' : 'Next',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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

class _OnboardPage extends StatelessWidget {
  const _OnboardPage({required this.data});

  final OnboardModel data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: SvgPicture.asset(
                data.image,
                fit: BoxFit.contain,
                placeholderBuilder: (context) => Container(
                  height: 220,
                  width: 220,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.image_outlined,
                    size: 64,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.darkGery,
              fontSize: 13,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
