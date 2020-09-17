import 'package:bloc/bloc.dart';
import 'package:lifestylediet/blocs/homescreen/home_event.dart';
import 'package:lifestylediet/blocs/homescreen/home_state.dart';
import 'package:lifestylediet/food_api/example.dart';
import 'package:openfoodfacts/model/Product.dart';

class HomeBloc extends Bloc<HomeEvent,HomeState> {
  @override
  HomeState get initialState => HomeLoadingState();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if(event is HomeLoad) {
   yield HomeLoadingState();
        Product product = await getProduct();
        yield HomeLoadedState(product);
    }
  }
}