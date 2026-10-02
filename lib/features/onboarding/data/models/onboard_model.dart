import '../../../../core/utils/app_assets.dart';

class OnboardModel {
  final String title;
  final String description;
  final String image;

  const OnboardModel({
    required this.title,
    required this.description,
    required this.image,
  });
}

// TODO: add more slides here whenever new Figma screens are sent.
List<OnboardModel> onboardData = [
  OnboardModel(
    title: 'Choose Products',
    description:
        'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit.',
    image: AppImages.onboardingChooseProducts,
  ),
  OnboardModel(
    title: 'Make Payment',
    description:
        'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit.',
    image: AppImages.onboardingMakePayment,
  ),
  OnboardModel(
    title: 'Get Your Order',
    description:
        'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit.',
    image: AppImages.onboardingGetOrder,
  ),
];
