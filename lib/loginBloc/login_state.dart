import 'package:equatable/equatable.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:meta/meta.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginLoading extends LoginState {}

class LoginLoaded extends LoginState {
  final bool token;

  LoginLoaded({@required this.token});

  @override
  List<Object> get props => [token];
}

class LoginSuccess extends LoginState {
  final User user;

  LoginSuccess(this.user);
}

class LoginFailure extends LoginState {}

class RegisterLoading extends LoginState {}
