import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/repositories/repositories.dart';
import 'package:lifestylediet/utils/i18n.dart';

import 'bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  UserRepository _repository = UserRepository();
  String _uid;
  String _currentDate;
  PersonalData personalData;
  Users _user;
  DateFormat dateFormat = new DateFormat("yyyy-MM-dd");
  String strDate;

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
    strDate = dateFormat.format(DateTime.now());
    DatabaseUserRepository _databaseUserRepository =
        DatabaseUserRepository(uid: uid);
    personalData = await _databaseUserRepository.getUserPersonalData();
    if (personalData != null) {
      yield LoginSuccess(_uid, strDate);
    } else {
      yield* _createNewProfile();
    }
  }

  Stream<AuthState> _createNewProfile() async* {
    if (_repository.emailVerified) {
      yield PersonalDataState();
    } else {
      yield VerifyEmail(i18n.verifyEmail);
    }
  }

  Stream<AuthState> _mapPersonalDataState(PersonalDataEvent event) async* {
    yield PersonalDataResult();
  }

  Stream<AuthState> _mapResetPasswordState(ResetPassword event) async* {
    try {
      await _repository.resetPassword(event.email);
      yield ConfirmEmail(i18n.resetPasswordSuccess, event.scaffoldKey);
    } catch (Exception) {
      yield ConfirmEmail(i18n.resetPasswordFailure, event.scaffoldKey);
    }
  }

  Stream<AuthState> _mapRegisterState(Register event) async* {
    _user = event.user;
    bool result = await _repository.register(getUser(event));
    if (result) {
      await _repository.verifyEmail();
      yield RegisterSuccess(i18n.registerSuccess);
    } else {
      yield RegisterState(i18n.registerFailure, event.scaffoldKey);
    }
  }

  Stream<AuthState> _mapGoalsResultState(GoalsEvent event) async* {
    await _repository.login(_user);
    DatabaseUserRepository _databaseRepository =
        DatabaseUserRepository(uid: _repository.uid);
    await _databaseRepository.addUserPersonalData(personalData: personalData);
    strDate = dateFormat.format(DateTime.now());

    yield LoginSuccess(uid, strDate);
  }

  getUser(event) {
    return Users(event.user.email, event.user.password);
  }
}
