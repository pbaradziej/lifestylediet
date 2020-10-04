import 'package:bloc/bloc.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/repositories/user_repository.dart';
import 'bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _repository = UserRepository();
  String _uid;

  String get uid => _uid;

  @override
  LoginState get initialState => LoginLoading();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginLoad) {
      yield* _mapLoginLoadState();
    } else if (event is Login) {
      yield* _mapLoginState(event);
    } else if (event is Register) {
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
      _uid = _repository.uid;
      yield LoginSuccess(event.user);
    } else {
      yield LoginFailure();
    }
  }

  Stream<LoginState> _mapRegisterLoadState() async* {
    yield RegisterLoading();
  }

  getUser(event) {
    return Users(event.user.email, event.user.password);
  }
}
