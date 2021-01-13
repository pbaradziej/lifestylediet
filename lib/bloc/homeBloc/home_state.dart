import 'package:equatable/equatable.dart';
import 'package:lifestylediet/models/models.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeLoadingState extends HomeState {}

class HomeLoadedState extends HomeState {
  final List<Meal> meals;
  final Nutrition nutrition;

  HomeLoadedState(this.meals, this.nutrition);

  @override
  List<Object> get props => [meals, nutrition];
}

class HomeAddingState extends HomeState {}

class HomeLogoutState extends HomeState {}
