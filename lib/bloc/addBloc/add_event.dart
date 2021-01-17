import 'package:equatable/equatable.dart';
import 'package:lifestylediet/models/models.dart';

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
  final String currentDate;
  final double amount;
  final String value;

  AddProduct({
    this.uid,
    this.meal,
    this.product,
    this.amount,
    this.value,
    this.currentDate,
  });

  @override
  List<Object> get props => [uid, meal, product, amount, value, currentDate];
}

class AddProductList extends AddEvent {
  final String uid;
  final String meal;
  final String currentDate;
  final List<DatabaseProduct> products;

  AddProductList({
    this.uid,
    this.meal,
    this.products,
    this.currentDate,
  });

  @override
  List<Object> get props => [uid, meal, products, currentDate];
}

class DatabaseProductList extends AddEvent {
  final String uid;

  DatabaseProductList(this.uid);

  @override
  List<Object> get props => [uid];
}
