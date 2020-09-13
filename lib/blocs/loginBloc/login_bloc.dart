import 'package:bloc/bloc.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/repositories/user_repository.dart';
import 'bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _repository = UserRepository();

  @override
  LoginState get initialState => LoginLoading();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginLoad) {
      yield* _mapLoginLoadState();
    } else if (event is Login) {
      yield* _mapLoginState(event);
    } else if (event is Logout) {
      yield* _mapLogoutState(event);
    } else if (event is RegisterLoad) {
      yield* _mapRegisterLoadState();
    }
  }

  Stream<LoginState> _mapLoginLoadState() async* {
    yield LoginLoaded();
  }

  Stream<LoginState> _mapLoginState(Login event) async* {
    yield LoginLoading();
    bool result = await _repository.login(getUser(event));
    if (result) {
      yield LoginSuccess(event.user);
    } else {
      yield LoginFailure();
    }
  }

  Stream<LoginState> _mapLogoutState(Logout event) async* {
    yield LoginLoading();
    await _repository.logout();
    yield LoginLoaded();
  }

  Stream<LoginState> _mapRegisterLoadState() async* {
    yield RegisterLoading();
  }

  getUser(event) {
    return Users(event.user.email, event.user.password);
  }
}
