// lib/features/onboarding/domain/entities/onboarding_model.dart

class OnboardingModel {
  final String title;
  final String description;
  final String image;

  OnboardingModel({
    required this.title,
    required this.description,
    required this.image,
  });

  static List<OnboardingModel> onboardingPages = [
    OnboardingModel(
      title: 'Welcome',
      description: 'Discover amazing features that will make your life easier',
      image: '🚀',
    ),
    OnboardingModel(
      title: 'Easy to Use',
      description: 'Simple and intuitive interface designed for everyone',
      image: '✨',
    ),
    OnboardingModel(
      title: 'Get Started',
      description: 'Join us today and start your amazing journey',
      image: '🎯',
    ),
  ];
}
