import 'package:bloc/bloc.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/repositories/repositories.dart';
import 'bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  List<User> _users = [];
  UserRepository _repository = UserRepository();

  @override
  RegisterState get initialState => RegisterState();

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterInit) {
      yield* _mapRegisterLoadState();
    } else if (event is Register) {
      yield* _mapRegisterState(event);
    }
  }

  Stream<RegisterState> _mapRegisterLoadState() async* {
    if(await _repository.loadUser() != null) {
      _users = await _repository.loadUser();
    }
    yield RegisterLoaded(token: false);
  }

  Stream<RegisterState> _mapRegisterState(Register event) async* {
      _users = await _repository.loadUser()??[];
    if (event.user.login != null && event.user.password != null) {
      for (User user in _users) {
        if(event.user.login == user.login) {
          yield RegisterFailure();
          return;
        }
      }
      _users.add(event.user);
      await _repository.saveUser(_users);
      yield RegisterSuccess(_users);
    } else {
      yield RegisterFailure();
    }
  }
}
