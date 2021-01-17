import 'package:equatable/equatable.dart';

class RegisterState extends Equatable {
  @override
  List<Object> get props => [];
}

class RegisterLoading extends RegisterState {}

class RegisterLoaded extends RegisterState {}

class ReturnLogin extends RegisterState {}

class RegisterResult extends RegisterState {
  final bool result;

  RegisterResult(this.result);

  @override
  List<Object> get props => [result];
}

class PersonalDataResult extends RegisterState {
  final String email;
  final String password;
  final String sex;
  final String date;
  final String firstName;
  final String lastName;

  PersonalDataResult({
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
