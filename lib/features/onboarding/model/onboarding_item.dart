/// Data for a single onboarding page. Params: [image]: illustration asset path from [IllustrationPath], SVG or raster. [title]: translation key from [AppStrings]. [description]: translation key from [AppStrings].
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
