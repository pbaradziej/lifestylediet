import 'package:equatable/equatable.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/models/weight_progress.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeLoadingState extends HomeState {}

class HomeLoadedState extends HomeState {
  final List<Meal> meals;
  final Nutrition nutrition;
  final PersonalData personalData;
  final List<WeightProgress> weightProgress;
  final NutrimentsData nutrimentsData;

  HomeLoadedState(
    this.meals,
    this.nutrition,
    this.personalData,
    this.weightProgress,
    this.nutrimentsData,
  );

  @override
  List<Object> get props => [
        meals,
        nutrition,
        personalData,
        weightProgress,
        nutrimentsData,
      ];
}

class HomeAddingState extends HomeState {}

class HomeLogoutState extends HomeState {}
