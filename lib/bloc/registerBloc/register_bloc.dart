import 'package:bloc/bloc.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/repositories/repositories.dart';
import 'bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  UserRepository _repository = UserRepository();
  String _uidPD;

  @override
  RegisterState get initialState => RegisterLoading();

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterLoad) {
      yield* _mapRegisterLoadedState(event);
    } else if (event is Register) {
      yield* _mapRegisterState(event);
    } else if (event is Return) {
      yield* _mapLoginState(event);
    } else if (event is PersonalDataEvent) {
      yield PersonalDataResult(
        email: event.email,
        password: event.password,
        sex: event.sex,
        firstName: event.firstName,
        lastName: event.lastName,
        date: event.date,
      );
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
    bool result = await _repository.login(Users(event.email, event.password));
    if (result) {
      _uidPD = _repository.uid + "PD";
      DatabaseRepository _databaseRepository = DatabaseRepository(uid: _uidPD);
      _databaseRepository.addUserPersonalData(personalData: event.personalData);
      _databaseRepository.setUid(_repository.uid);
      _databaseRepository.addUserWeight(weight: event.personalData.weight);
      await _repository.logout();
      yield ReturnLogin();
    }
  }

  getUser(event) {
    return Users(event.user.email, event.user.password);
  }
}
