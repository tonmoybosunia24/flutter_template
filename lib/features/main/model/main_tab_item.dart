/// Data for a single bottom navigation tab. [icon] is an icon asset path from [IconPath] and [label] is a translation key from [AppStrings].
class MainTabItem {
  final String icon;
  final String label;

  const MainTabItem({
    required this.icon,
    required this.label,
  });
}
