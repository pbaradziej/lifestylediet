import 'package:equatable/equatable.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:meta/meta.dart';

class RegisterState extends Equatable{

  @override
  List<Object> get props => [];
}

class RegisterLoaded extends RegisterState {
  final bool token;

  RegisterLoaded({@required this.token});

  @override
  List<Object> get props => [token];
}

class RegisterSuccess extends RegisterState {
  final List<User> users;

  RegisterSuccess(this.users);

  @override
  List<Object> get props => [users];
}

class RegisterFailure extends RegisterState {}