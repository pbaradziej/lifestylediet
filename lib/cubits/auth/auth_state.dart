part of 'auth_cubit.dart';

enum AuthStatus {
  initial,
  authenticated,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final bool canLogin;
  final Key key;

  AuthState({
    required this.status,
    this.canLogin = false,
  }) : key = UniqueKey();

  @override
  List<Object> get props => <Object>[
        status,
        canLogin,
        key,
      ];
}
