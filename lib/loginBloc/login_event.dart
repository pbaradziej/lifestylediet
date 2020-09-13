import 'package:equatable/equatable.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:meta/meta.dart';

abstract class LoginEvent extends Equatable {
  LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginLoad extends LoginEvent {}

class Login extends LoginEvent {
  final Users user;

  Login({@required this.user});

  @override
  List<Object> get props => [user];
}

class RegisterLoad extends LoginEvent {}

class Logout extends LoginEvent {}
