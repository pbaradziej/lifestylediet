import 'package:bloc/bloc.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/repositories/user_repository.dart';
import 'bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  List<User> _users;
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
    _users = await _repository.loadUser();
    yield LoginLoaded(token: false);
  }

  Stream<LoginState> _mapLoginState(Login event) async* {
    yield LoginLoading();
    bool loginSuccessful = false;
    if (_users != null)
      for (User user in _users) {
        if (event.user.login == user.login &&
            event.user.password == user.password) loginSuccessful = true;
      }
    if (loginSuccessful) {
      yield LoginSuccess(event.user);
    } else {
      yield LoginFailure();
    }
  }

  Stream<LoginState> _mapLogoutState(Logout event) async* {
    yield LoginLoading();
    yield LoginLoaded(token: false);
  }

  Stream<LoginState> _mapRegisterLoadState() async* {
    yield RegisterLoading();
  }
}
