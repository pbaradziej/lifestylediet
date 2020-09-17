import 'package:equatable/equatable.dart';
import 'package:openfoodfacts/model/Product.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeLoadingState extends HomeState {}

class HomeLoadedState extends HomeState {
  final Product product;

  HomeLoadedState(this.product);

  @override
  List<Object> get props => [product];
}