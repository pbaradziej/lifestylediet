part of 'login_cubit.dart';

enum LoginStatus {
  initial,
  loaded,
  initialPersonalData,
  initialGoals,
  notVerified,
  authenticated,
  loginError,
  register,
}

class LoginState extends Equatable {
  final LoginStatus status;
  final PersonalData personalData;
  final String email;
  final String message;
  final Key key;

  LoginState({
    required this.status,
    final PersonalData? personalData,
    this.email = '',
    this.message = '',
  })  : personalData = personalData ?? PersonalData(),
        key = UniqueKey();

  @override
  List<Object> get props => <Object>[
        status,
        personalData,
        email,
        message,
        key,
      ];
}
