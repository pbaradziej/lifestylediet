import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/repositories/repositories.dart';

import 'bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  UserRepository _repository = UserRepository();
  String _uid;
  String _currentDate;
  PersonalData _personalData;
  Users _user;

  String get uid => _uid;

  void setCurrentDate(String currentDate) {
    this._currentDate = currentDate;
  }

  @override
  AuthState get initialState => LoginLoading();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is LoginLoad) {
      yield* _mapLoginLoadState();
    } else if (event is Login) {
      yield* _mapLoginState(event);
    } else if (event is Register) {
      yield* _mapRegisterState(event);
    } else if (event is ResetPassword) {
      yield* _mapResetPasswordState(event);
    } else if (event is PersonalDataEvent) {
      yield* _mapPersonalDataState(event);
    } else if (event is GoalsEvent) {
      yield* _mapGoalsResultState(event);
    }
  }

  Stream<AuthState> _mapLoginLoadState() async* {
    yield LoginLoaded();
  }

  Stream<AuthState> _mapLoginState(Login event) async* {
    yield LoginLoading();
    bool result = await _repository.login(getUser(event));
    if (result) {
      yield* _loginSuccessful();
    } else {
      yield LoginFailure();
    }
  }

  Stream<AuthState> _loginSuccessful() async* {
    _uid = _repository.uid;
    DateFormat dateFormat = new DateFormat("yyyy-MM-dd");
    String strDate = dateFormat.format(DateTime.now());
    DatabaseUserRepository _databaseUserRepository =
        DatabaseUserRepository(uid: uid);
    _personalData = await _databaseUserRepository.getUserPersonalData();
    if (_personalData != null) {
      yield LoginSuccess(_uid, strDate);
    } else {
      yield* _createNewProfile();
    }
  }

  Stream<AuthState> _createNewProfile() async* {
    if (_repository.emailVerified) {
      yield PersonalDataState();
    } else {
      yield VerifyEmail("Please verify your email");
    }
  }

  Stream<AuthState> _mapPersonalDataState(PersonalDataEvent event) async* {
    _personalData = event.personalData;
    yield PersonalDataResult();
  }

  Stream<AuthState> _mapResetPasswordState(ResetPassword event) async* {
    String message = "Check your email to reset password";
    try {
      await _repository.resetPassword(event.email);
    } catch (Exception) {
      message = "Failed to send reset password to email";
    }

    yield ConfirmEmail(message, event.scaffoldKey);
  }

  Stream<AuthState> _mapRegisterState(Register event) async* {
    String message = "";
    _user = event.user;
    bool result = await _repository.register(getUser(event));
    if (result) {
      message = "Registered successfully, Please verify your email";
      await _repository.verifyEmail();
      yield RegisterSuccess(message);
    } else {
      message = "Email is already in use";
      yield RegisterState(message, event.scaffoldKey);
    }
  }

  Stream<AuthState> _mapGoalsResultState(GoalsEvent event) async* {
    PersonalData personalData = event.personalData;
    _personalData.weight = personalData.weight;
    _personalData.height = personalData.height;
    _personalData.activity = personalData.activity;
    _personalData.goal = personalData.goal;
    await _repository.login(_user);
    DatabaseUserRepository _databaseRepository =
        DatabaseUserRepository(uid: _repository.uid);
    await _databaseRepository.addUserPersonalData(personalData: _personalData);
    await _databaseRepository.addUserWeight(weight: _personalData.weight);
    DateFormat dateFormat = new DateFormat("yyyy-MM-dd");
    String strDate = dateFormat.format(DateTime.now());

    yield LoginSuccess(uid, strDate);
  }

  getUser(event) {
    return Users(event.user.email, event.user.password);
  }
}
