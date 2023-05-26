import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lifestylediet/models/personal_data.dart';
import 'package:lifestylediet/repositories/database_user_repository.dart';
import 'package:lifestylediet/repositories/user_repository.dart';
import 'package:lifestylediet/shared_repositories/user_credentials_provider.dart';
import 'package:lifestylediet/utils/i18n.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final UserRepository _userRepository;
  final DatabaseUserRepository _databaseUserRepository;
  final UserCredentialsProvider _userCredentialsProvider;

  LoginCubit()
      : _userRepository = UserRepository(),
        _databaseUserRepository = DatabaseUserRepository(),
        _userCredentialsProvider = UserCredentialsProvider(),
        super(LoginState(status: LoginStatus.initial));



  Future<void> initializeAuthentication() async {
    final String uid = await _userCredentialsProvider.readUid();
    final bool isLoggedIn = uid.isNotEmpty;
    if (isLoggedIn) {
      await _initializeLoggedUser();
    } else {
      _emitLoginState(status: LoginStatus.loaded);
    }
  }

  Future<void> login(final String email, final String password) async {
    final User? result = await _userRepository.login(
      email: email,
      password: password,
    );
    if (result != null) {
      await _userCredentialsProvider.saveUid(result.uid);
    } else {
      _emitLoginState(status: LoginStatus.loginError);
    }
  }

  void registerUser() {
    _emitLoginState(status: LoginStatus.register);
  }

  Future<void> register(final String email, final String password) async {
    final bool result = await _userRepository.register(
      email: email,
      password: password,
    );
    if (result) {
      await _userRepository.verifyEmail();
      _emitLoginState(
        status: LoginStatus.loaded,
        message: I18n.registerSuccess,
      );
    } else {
      _emitLoginState(
        status: LoginStatus.register,
        message: I18n.registerFailure,
      );
    }
  }

  Future<void> resetPassword(final String email) async {
    await _userRepository.resetPassword(email);
    _emitLoginState(
      status: LoginStatus.loaded,
      message: I18n.resetPassword,
    );
  }

  Future<void> authenticateData(final PersonalData personalData) async {
    await _databaseUserRepository.addUserPersonalData(personalData: personalData);
    _emitLoginState(status: LoginStatus.authenticated);
  }

  Future<void> showGoalsAuthenticationScreen(final PersonalData personalData) async {
    await _databaseUserRepository.addUserPersonalData(personalData: personalData);
    _emitLoginState(
      status: LoginStatus.initialGoals,
      personalData: personalData,
    );
  }

  Future<void> _initializeLoggedUser() async {
    final PersonalData personalData = await _databaseUserRepository.getUserPersonalData();
    final String email = await _userCredentialsProvider.readEmail();
    final LoginStatus loginStatus = _getInitialLoginStatus(personalData);
    final String message = _getMessage(loginStatus);

    _emitLoginState(
      status: loginStatus,
      email: email,
      message: message,
      personalData: personalData,
    );
  }

  String _getMessage(final LoginStatus status) {
    if (status == LoginStatus.notVerified) {
      return I18n.verifyEmail;
    }

    return '';
  }

  LoginStatus _getInitialLoginStatus(final PersonalData personalData) {
    final String firstName = personalData.firstName;
    final String goal = personalData.goal;

    if (firstName.isEmpty) {
      return LoginStatus.initialPersonalData;
    } else if (goal.isEmpty) {
      return LoginStatus.initialGoals;
    }

    return LoginStatus.notVerified;
  }

  void _emitLoginState({
    required final LoginStatus status,
    final String email = '',
    final String message = '',
    final PersonalData? personalData,
  }) {
    final LoginState state = LoginState(
      status: status,
      email: email,
      message: message,
      personalData: personalData,
    );
    emit(state);
  }
}
