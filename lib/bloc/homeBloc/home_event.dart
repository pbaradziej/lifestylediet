import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeLoad extends HomeEvent {
  final String uid;

  HomeLoad(this.uid);

  @override
  List<Object> get props => [uid];
}

class Logout extends HomeEvent {}

class AddProduct extends HomeEvent {
  final String meal;

  AddProduct(this.meal);

  @override
  List<Object> get props => [meal];
}

class UpdateProduct extends HomeEvent {
  final String id;
  final double amount;
  final String value;
  final int index;

  UpdateProduct({this.index, this.amount, this.value, this.id});

  @override
  List<Object> get props => [id, amount, value, index];
}

class DeleteProduct extends HomeEvent {
  final String id;
  final int index;

  DeleteProduct({this.id, this.index});

  @override
  List<Object> get props => [id, index];
}
