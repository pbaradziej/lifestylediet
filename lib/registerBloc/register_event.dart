import 'package:equatable/equatable.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:meta/meta.dart';

class RegisterEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class RegisterLoad extends RegisterEvent {}

class Return extends RegisterEvent {}

class Register extends RegisterEvent {
  final Users user;

  Register({@required this.user});

  @override
  List<Object> get props => [user];
}
