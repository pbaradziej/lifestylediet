import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:lifestylediet/models/personal_data.dart';
import 'package:lifestylediet/repositories/database_user_repository.dart';
import 'package:lifestylediet/repositories/user_repository.dart';
import 'package:lifestylediet/shared_repositories/user_credentials_provider.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final UserRepository _userRepository;
  final DatabaseUserRepository _databaseUserRepository;
  final UserCredentialsProvider _userCredentialsProvider;

  AuthCubit()
      : _userRepository = UserRepository(),
        _databaseUserRepository = DatabaseUserRepository(),
        _userCredentialsProvider = UserCredentialsProvider(),
        super(AuthState(status: AuthStatus.initial));

  void authenticate() {
    initializeAuthentication();
  }

  void initializeAuthentication() async {
    final PersonalData personalData = await _databaseUserRepository.getUserPersonalData();
    final String goal = personalData.goal;
    final bool canLogin = goal.isNotEmpty;
    _emitAuthState(canLogin);
  }

  void logout() async {
    await _userCredentialsProvider.clearUid();
    await _userRepository.logout();
  }

  void _emitAuthState(bool canLogin) {
    final AuthState state = AuthState(
      status: AuthStatus.authenticated,
      canLogin: canLogin,
    );
    emit(state);
  }
}
