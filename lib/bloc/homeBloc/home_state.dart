import 'package:equatable/equatable.dart';
import 'package:lifestylediet/models/databaseProduct.dart';
import 'package:lifestylediet/models/nutrition.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeLoadingState extends HomeState {}

class HomeLoadedState extends HomeState {
  final List<DatabaseProduct> breakfast;
  final List<DatabaseProduct> dinner;
  final List<DatabaseProduct> supper;
  final Nutrition nutrition;

  HomeLoadedState(this.breakfast, this.dinner, this.supper, this.nutrition);

  @override
  List<Object> get props => [breakfast, dinner, supper, nutrition];
}

class HomeAddingState extends HomeState {}

class HomeLogoutState extends HomeState {}
