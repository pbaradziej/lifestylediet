import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeLoadingState extends HomeState {}

class HomeLoadedState extends HomeState {}

class HomeAddingState extends HomeState {
  final String meal;
  final String currentDate;
  final String uid;

  HomeAddingState(this.meal, this.currentDate, this.uid);

  @override
  List<Object> get props => [meal, currentDate, uid];
}

class HomeLogoutState extends HomeState {}
