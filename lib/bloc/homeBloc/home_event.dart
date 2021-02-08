import 'package:equatable/equatable.dart';
import 'package:lifestylediet/models/models.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeLoad extends HomeEvent {}

class Logout extends HomeEvent {}

class AddProductScreen extends HomeEvent {
  final String meal;
  final String currentDate;

  AddProductScreen(this.meal, this.currentDate);

  @override
  List<Object> get props => [meal, currentDate];
}

class AddWeight extends HomeEvent {
  final String weight;

  AddWeight(this.weight);

  @override
  List<Object> get props => [weight];
}

class ChangePlan extends HomeEvent {
  final String plan;

  ChangePlan(this.plan);

  @override
  List<Object> get props => [plan];
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

class UpdateProfileData extends HomeEvent {
  final PersonalData personalData;

  UpdateProfileData({this.personalData});

  @override
  List<Object> get props => [personalData];
}

class DeleteProduct extends HomeEvent {
  final String id;
  final int index;

  DeleteProduct({this.id, this.index});

  @override
  List<Object> get props => [id, index];
}

class SearchRecipes extends HomeEvent {
  final String search;

  SearchRecipes(this.search);

  @override
  List<Object> get props => [search];
}

class AddRecipeProduct extends HomeEvent {
  final Recipe recipe;
  final String amount;
  final String meal;

  AddRecipeProduct(this.recipe, this.amount, this.meal);
}
