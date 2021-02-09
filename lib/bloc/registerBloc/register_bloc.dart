import 'package:bloc/bloc.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/repositories/repositories.dart';

import 'bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  UserRepository _repository = UserRepository();
  String _email;
  String _password;
  PersonalData _personalData;

  @override
  RegisterState get initialState => RegisterLoading();

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterLoad) {
      yield* _mapRegisterLoadedState(event);
    } else if (event is Register) {
      _email = event.user.email;
      _password = event.user.password;
      yield* _mapRegisterState(event);
    } else if (event is Return) {
      yield* _mapLoginState(event);
    } else if (event is PersonalDataEvent) {
      _personalData = event.personalData;
      yield PersonalDataResult();
    } else if (event is GoalsEvent) {
      yield* _mapGoalsResultState(event);
    }
  }

  Stream<RegisterState> _mapRegisterLoadedState(RegisterLoad event) async* {
    yield RegisterLoaded();
  }

  Stream<RegisterState> _mapRegisterState(Register event) async* {
    yield RegisterLoading();
    bool result = await _repository.register(getUser(event));
    yield RegisterResult(result);
  }

  Stream<RegisterState> _mapLoginState(Return event) async* {
    yield ReturnLogin();
  }

  Stream<RegisterState> _mapGoalsResultState(GoalsEvent event) async* {
    yield RegisterLoading();
    PersonalData personalData = event.personalData;
    bool result = await _repository.login(Users(_email, _password));
    _personalData.weight = personalData.weight;
    _personalData.height = personalData.height;
    _personalData.activity = personalData.activity;
    _personalData.goal = personalData.goal;
    if (result) {
      DatabaseUserRepository _databaseRepository =
          DatabaseUserRepository(uid: _repository.uid);
      _databaseRepository.addUserPersonalData(personalData: _personalData);
      _databaseRepository.addUserWeight(weight: _personalData.weight);
      await _repository.logout();
      yield ReturnLogin();
    }
  }

  getUser(event) {
    return Users(event.user.email, event.user.password);
  }
}
