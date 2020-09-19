import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeLoad extends HomeEvent {}

class HomeAddFood extends HomeEvent {}

class HomeLogout extends HomeEvent {}
