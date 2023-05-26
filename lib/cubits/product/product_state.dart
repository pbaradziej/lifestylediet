part of 'product_cubit.dart';

enum ProductStatus {
  loading,
  loaded,
  filtered,
  listProducts,
  notFound,
}

class ProductState extends Equatable {
  final ProductStatus status;
  final List<DatabaseProduct> products;
  final List<Meal> meals;
  final String message;
  final Key key;

  ProductState({
    required this.status,
    this.products = const <DatabaseProduct>[],
    this.meals = const <Meal>[],
    this.message = '',
  }) : key = UniqueKey();

  ProductState copyWith({
    final ProductStatus? status,
    final List<DatabaseProduct>? products,
    final List<Meal>? meals,
    final String? message,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      meals: meals ?? this.meals,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => <Object>[
        status,
        products,
        meals,
        message,
        key,
      ];
}
