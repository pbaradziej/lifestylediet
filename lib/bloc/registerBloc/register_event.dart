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

class PersonalDataEvent extends RegisterEvent {
  final String email;
  final String password;
  final String sex;
  final String date;
  final String firstName;
  final String lastName;

  PersonalDataEvent({
    this.email,
    this.password,
    this.sex,
    this.date,
    this.firstName,
    this.lastName,
  });

  @override
  List<Object> get props => [email, password, sex, date, firstName, lastName];
}

class GoalsEvent extends RegisterEvent {
  final String email;
  final String password;
  final PersonalData personalData;

  GoalsEvent({this.email, this.password, this.personalData});

  @override
  List<Object> get props => [email, password, personalData];
}
