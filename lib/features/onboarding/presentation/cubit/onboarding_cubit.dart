import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/features/onboarding/data/models/onboard_model.dart';
import 'package:shop/features/onboarding/presentation/cubit/onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingInitState());

  static OnboardingCubit get(context) => BlocProvider.of(context);

  final PageController pageController = PageController();
  int currentIndex = 0;

  bool get isLastPage => currentIndex == onboardData.length - 1;

  void onPageChanged(int index) {
    currentIndex = index;
    emit(OnboardingPageChangedState());
  }

  void next() {
    if (isLastPage) {
      emit(OnboardingFinishedState());
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void prev() {
    if (currentIndex > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skip() {
    emit(OnboardingFinishedState());
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
