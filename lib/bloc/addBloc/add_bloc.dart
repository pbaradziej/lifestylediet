import 'package:bloc/bloc.dart';
import 'package:lifestylediet/food_api/productSearch.dart';
import 'package:lifestylediet/repositories/database_repository.dart';
import 'package:openfoodfacts/model/Product.dart';

import 'bloc.dart';

class AddBloc extends Bloc<AddEvent, AddState> {
  ProductSearch _product = ProductSearch();

  @override
  AddState get initialState => AddLoadedState();

  @override
  Stream<AddState> mapEventToState(AddEvent event) async* {
    if (event is InitialScreen) {
      yield AddLoadedState();
    } else if (event is SearchFood) {
      yield* mapSearchFood(event);
    } else if (event is AddReturn) {
      yield AddReturnState();
    } else if (event is AddProduct) {
      yield* mapAddProduct(event);
    }
  }

  Stream<AddState> mapSearchFood(SearchFood event) async* {
    yield AddLoadingState();
    List<Product> _products = await _product.searchProducts(event.search);
    yield AddSearchState(_products);
  }

  Stream<AddState> mapAddProduct(AddProduct event) async* {
    yield AddLoadingState();
    await DatabaseRepository(uid: event.uid).addUserData(
        meal: event.meal,
        product: event.product,
        amount: event.amount,
        value: event.value);
    yield AddReturnState();
  }
}
