import 'package:equatable/equatable.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

abstract class AddEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchFood extends AddEvent {
  final String search;

  SearchFood(this.search);

  @override
  List<Object> get props => [search];
}

class AddFood extends AddEvent {}

class AddReturn extends AddEvent {}

class AddProduct extends AddEvent {
  final String uid;
  final String meal;
  final Product product;
  final double amount;
  final String value;

  AddProduct({this.uid, this.meal, this.product, this.amount, this.value});

  @override
  List<Object> get props => [uid, meal, product, amount, value];
}
