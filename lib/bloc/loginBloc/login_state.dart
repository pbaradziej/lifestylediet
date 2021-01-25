import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginLoading extends LoginState {}

class LoginLoaded extends LoginState {}

class LoginSuccess extends LoginState {
  final String uid;
  final String currentDate;

  LoginSuccess(this.uid, this.currentDate);

  @override
  List<Object> get props => [uid, currentDate];
}

class LoginFailure extends LoginState {}

class RegisterLoadingState extends LoginState {}
