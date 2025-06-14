class CurrencyFormatter {
  static const double _usdToPkrRate = 280.0; // 1 USD = 280 PKR

  static String formatPrice(double usdPrice) {
    final pkrPrice = usdPrice * _usdToPkrRate;
    return '₨${pkrPrice.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        )}';
  }

  static String formatPriceRange(String range) {
    if (range.contains('Under \$')) {
      final amount = double.parse(range.replaceAll('Under \$', ''));
      return 'Under ${formatPrice(amount)}';
    } else if (range.contains('\$')) {
      final parts = range.split(' - \$');
      if (parts.length == 2) {
        final start = double.parse(parts[0].replaceAll('\$', ''));
        final end = double.parse(parts[1]);
        return '${formatPrice(start)} - ${formatPrice(end)}';
      }
    }
    return range;
  }
} 