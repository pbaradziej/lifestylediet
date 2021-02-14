import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginLoading extends AuthState {}

class LoginLoaded extends AuthState {}

class LoginSuccess extends AuthState {
  final String uid;
  final String currentDate;

  LoginSuccess(this.uid, this.currentDate);

  @override
  List<Object> get props => [uid, currentDate];
}

class LoginFailure extends AuthState {}

class RegisterSuccess extends AuthState {
  final String message;

  RegisterSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class RegisterState extends AuthState {
  final String message;
  final GlobalKey<ScaffoldState> scaffoldKey;

  RegisterState(this.message, this.scaffoldKey);

  @override
  List<Object> get props => [message, scaffoldKey];
}

class ConfirmEmail extends AuthState {
  final String message;
  final GlobalKey<ScaffoldState> scaffoldKey;

  ConfirmEmail(this.message, this.scaffoldKey);

  @override
  List<Object> get props => [message, scaffoldKey];
}

class PersonalDataState extends AuthState {}

class PersonalDataResult extends AuthState {}

class VerifyEmail extends AuthState {
  final String message;

  VerifyEmail(this.message);

  @override
  List<Object> get props => [message];
}
