import 'package:lifestylediet/models/database_product.dart';

class ProductPanel {
  final DatabaseProduct databaseProduct;
  final bool isExpanded;

  ProductPanel({
    required this.databaseProduct,
    required this.isExpanded,
  });

  ProductPanel copyWith({
    final DatabaseProduct? databaseProduct,
    final bool? isExpanded,
  }) {
    return ProductPanel(
      databaseProduct: databaseProduct ?? this.databaseProduct,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  static List<ProductPanel> createProductPanels(final List<DatabaseProduct> products) {
    return <ProductPanel>[
      for (DatabaseProduct product in products)
        ProductPanel(
          databaseProduct: product,
          isExpanded: true,
        )
    ];
  }
}
