import 'package:equatable/equatable.dart';
import 'package:lifestylediet/models/models.dart';

abstract class AddEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchProduct extends AddEvent {
  final String search;

  SearchProduct(this.search);

  @override
  List<Object> get props => [search];
}

class InitialScreen extends AddEvent {}

class AddFood extends AddEvent {}

class AddReturn extends AddEvent {}

class AddProduct extends AddEvent {
  final DatabaseProduct product;
  final double amount;
  final String value;

  AddProduct({
    this.product,
    this.amount,
    this.value,
  });

  @override
  List<Object> get props => [product, amount, value];
}

class AddProductList extends AddEvent {
  final List<DatabaseProduct> products;

  AddProductList({this.products});

  @override
  List<Object> get props => [products];
}

class DatabaseProductList extends AddEvent {}
