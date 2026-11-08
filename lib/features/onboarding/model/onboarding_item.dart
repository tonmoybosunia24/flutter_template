/// Data for a single onboarding page. [image] is an SVG asset path (see [IconPath]), while [title] and [description] are translation keys from [AppStrings].
class OnboardingItem {
  final String image;
  final String title;
  final String description;

  const OnboardingItem({
    required this.image,
    required this.title,
    required this.description,
  });
}
