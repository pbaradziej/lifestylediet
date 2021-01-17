import 'package:equatable/equatable.dart';
import 'package:lifestylediet/models/models.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginLoading extends LoginState {}

class LoginLoaded extends LoginState {}

class LoginSuccess extends LoginState {
  final Users user;

  LoginSuccess(this.user);
}

class LoginFailure extends LoginState {}

class RegisterLoadingState extends LoginState {}
