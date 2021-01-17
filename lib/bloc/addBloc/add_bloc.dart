import 'package:bloc/bloc.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/repositories/repositories.dart';

import 'bloc.dart';

class AddBloc extends Bloc<AddEvent, AddState> {
  @override
  AddState get initialState => AddLoadedState();

  @override
  Stream<AddState> mapEventToState(AddEvent event) async* {
    if (event is InitialScreen) {
      yield AddLoadedState();
    } else if (event is SearchFood) {
      yield* _mapSearchFood(event);
    } else if (event is AddReturn) {
      yield AddReturnState();
    } else if (event is AddProduct) {
      yield* _mapAddProduct(event);
    } else if (event is AddProductList) {
      yield* _mapAddProductList(event);
    } else if (event is DatabaseProductList) {
      yield* _mapDatabaseProductList(event);
    }
  }

  Stream<AddState> _mapSearchFood(SearchFood event) async* {
    yield AddLoadingState();

    await Future.delayed(Duration(seconds: 1));

    yield AddLoadedState();
  }

  Stream<AddState> _mapAddProduct(AddProduct event) async* {
    yield AddLoadingState();
    await DatabaseRepository(uid: event.uid).addUserData(
        meal: event.meal,
        currentDate: event.currentDate,
        product: event.product,
        amount: event.amount,
        value: event.value);

    yield AddReturnState();
  }

  Stream<AddState> _mapAddProductList(AddProductList event) async* {
    yield AddLoadingState();
    List<DatabaseProduct> products = event.products;
    products.forEach((product) async {
      await DatabaseRepository(uid: event.uid).addUserData(
          meal: event.meal,
          currentDate: event.currentDate,
          product: product,
          amount: product.amount,
          value: product.value);
    });

    yield AddReturnState();
  }

  Stream<AddState> _mapDatabaseProductList(DatabaseProductList event) async* {
    yield AddLoadingState();
    List<DatabaseProduct> _productsList;
    DatabaseRepository databaseRepository =
        new DatabaseRepository(uid: event.uid);
    _productsList = await databaseRepository.getDatabaseData();
    yield DatabaseProductsState(_productsList);
  }
}
