import 'package:equatable/equatable.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:meta/meta.dart';

class RegisterEvent extends Equatable{

  @override
  List<Object> get props => [];
}

class RegisterInit extends RegisterEvent {}

class Register extends RegisterEvent {
  final User user;

  Register({@required this.user});

  @override
  List<Object> get props => [user];
}