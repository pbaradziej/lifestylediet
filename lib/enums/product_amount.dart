enum ProductAmount {
  SERVING,
  GRAMS,
}

extension ProductAmountExtension on ProductAmount {
  static String get _serving => 'serving';

  static String get _grams => '100g';

  String get name {
    switch (this) {
      case ProductAmount.SERVING:
        return _serving;
      default:
        return _grams;
    }
  }

  static ProductAmount fromName(String? name) {
    if (name == _serving) {
      return ProductAmount.SERVING;
    } else {
      return ProductAmount.GRAMS;
    }
  }
}
