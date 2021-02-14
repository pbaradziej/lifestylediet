import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:meta/meta.dart';

abstract class AuthEvent extends Equatable {
  AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginLoad extends AuthEvent {}

class Login extends AuthEvent {
  final Users user;

  Login({@required this.user});

  @override
  List<Object> get props => [user];
}

class Register extends AuthEvent {
  final Users user;
  final GlobalKey<ScaffoldState> scaffoldKey;

  Register({@required this.user, this.scaffoldKey});

  @override
  List<Object> get props => [user, scaffoldKey];
}

class ResetPassword extends AuthEvent {
  final String email;
  final GlobalKey<ScaffoldState> scaffoldKey;

  ResetPassword(this.email, this.scaffoldKey);

  @override
  List<Object> get props => [email, scaffoldKey];
}

class PersonalDataEvent extends AuthEvent {
  final PersonalData personalData;

  PersonalDataEvent({
    this.personalData,
  });

  @override
  List<Object> get props => [personalData];
}

class GoalsEvent extends AuthEvent {
  final PersonalData personalData;

  GoalsEvent({this.personalData});

  @override
  List<Object> get props => [personalData];
}