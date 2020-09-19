import 'package:bloc/bloc.dart';
import 'package:lifestylediet/repositories/user_repository.dart';
import 'bloc.dart';
import 'package:lifestylediet/food_api/ProductSearch.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  ProductSearch _product = ProductSearch();
  UserRepository _repository = UserRepository();

  @override
  HomeState get initialState => HomeLoadingState();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is HomeLoad) {
      yield HomeLoadedState();
    } else if (event is HomeAddFood) {
      yield HomeAddingState();
    } else if (event is HomeLogout) {
      yield HomeLoadingState();
      await _repository.logout();
      yield HomeLogoutState();
    }
  }
}
