/// This class contains all the image asset paths used across the application.Use [ImagePath] constants instead of hardcoded strings to load images safely and consistently.
class ImagePath {
  // Private constructor to prevent instantiation
  ImagePath._();
  // Base directory path for all image assets
  static const String asset = 'assets/images/';
  // Product images
  static const String productHeadphones = '${asset}product_headphones.png';
  static const String productSneakers = '${asset}product_sneakers.png';
  static const String productWatch = '${asset}product_watch.png';
  // Profile images
  static const String profileAvatar = '${asset}profile_avatar.jpg';
}
