import 'package:equatable/equatable.dart';
import 'package:lifestylediet/models/databaseProduct.dart';

abstract class AddState extends Equatable {
  @override
  List<Object> get props => [];
}

class AddLoadingState extends AddState {}

class AddSearchState extends AddState {
  final List<DatabaseProduct> products;

  AddSearchState(this.products);

  @override
  List<Object> get props => [products];
}

class AddLoadedState extends AddState {}

class AddReturnState extends AddState {}

class ProductNotFoundState extends AddState {}
