import 'package:equatable/equatable.dart';
import 'package:lifestylediet/models/databaseProduct.dart';

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

class InitialScreen extends AddEvent {}

class AddFood extends AddEvent {}

class AddReturn extends AddEvent {}

class AddProduct extends AddEvent {
  final String uid;
  final String meal;
  final DatabaseProduct product;
  final double amount;
  final String value;

  AddProduct({this.uid, this.meal, this.product, this.amount, this.value});

  @override
  List<Object> get props => [uid, meal, product, amount, value];
}
