class OnboardingItem {
  final String title;
  final String description;

  const OnboardingItem({
    required this.title,
    required this.description,
  });
}

final List<OnboardingItem> onboardingItems = [
  const OnboardingItem(
    title: 'Discover Tech Products',
    description: 'Explore the latest and greatest tech products from top brands around the world.',
  ),
  const OnboardingItem(
    title: 'Easy Secure Shopping',
    description: 'Shop with confidence with our secure payment options and user-friendly interface.',
  ),
  const OnboardingItem(
    title: 'Fast Delivery',
    description: 'Get your tech products delivered quickly to your doorstep with our express shipping.',
  ),
]; 