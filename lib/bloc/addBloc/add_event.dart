import 'package:equatable/equatable.dart';

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