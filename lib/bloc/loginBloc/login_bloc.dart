import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/repositories/repositories.dart';

import 'bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _repository = UserRepository();
  String _uid;
  String _currentDate;

  String get uid => _uid;

  void setCurrentDate(String currentDate) {
    this._currentDate = currentDate;
  }

  @override
  LoginState get initialState => LoginLoading();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginLoad) {
      yield* _mapLoginLoadState();
    } else if (event is Login) {
      yield* _mapLoginState(event);
    } else if (event is RegisterLoadEvent) {
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
      DateFormat dateFormat = new DateFormat("yyyy-MM-dd");
      String strDate = dateFormat.format(DateTime.now());
      yield LoginSuccess(_uid, strDate);
    } else {
      yield LoginFailure();
    }
  }

  Stream<LoginState> _mapRegisterLoadState() async* {
    yield RegisterLoadingState();
  }

  getUser(event) {
    return Users(event.user.email, event.user.password);
  }
}
