import 'package:bloc/bloc.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/repositories/repositories.dart';
import 'bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  UserRepository _repository = UserRepository();

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
    }
  }

  Stream<RegisterState> _mapRegisterLoadedState(RegisterLoad event) async* {
    yield RegisterLoaded();
  }

  Stream<RegisterState> _mapRegisterState(Register event) async* {
    yield RegisterLoading();
    bool result = await _repository.register(getUser(event));
    if (result) {
      yield ReturnLogin();
    } else {
      yield RegisterFailure();
    }
  }

  Stream<RegisterState> _mapLoginState(Return event) async* {
    yield ReturnLogin();
  }

  getUser(event) {
    return Users(event.user.email, event.user.password);
  }
}
