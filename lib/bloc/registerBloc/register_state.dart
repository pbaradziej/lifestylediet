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

class PersonalDataResult extends RegisterState {}
