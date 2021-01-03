import 'package:bloc/bloc.dart';
import 'package:lifestylediet/models/databaseProduct.dart';
import 'package:lifestylediet/repositories/database_repository.dart';
import 'package:lifestylediet/repositories/product_repository.dart';

import 'bloc.dart';

class AddBloc extends Bloc<AddEvent, AddState> {
  ProductRepository _productRepository = ProductRepository();

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
    List<DatabaseProduct> _productsList;
    try {
      _productsList = await _productRepository.getSearchProducts(event.search);
    } catch (Exception) {
      yield ProductNotFoundState();
      return;
    }

    yield AddSearchState(_productsList);
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
