import 'package:bloc/bloc.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/repositories/repositories.dart';

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
    } else if(event is AddProductList) {
      yield* mapAddProductList(event);
    }
  }

  Stream<AddState> mapSearchFood(SearchFood event) async* {
    yield AddLoadingState();

    await Future.delayed(Duration(seconds: 1));

    yield AddLoadedState();
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

  Stream<AddState> mapAddProductList(AddProductList event) async* {
    yield AddLoadingState();
    List<DatabaseProduct> products = event.products;
    products.forEach((product) async {
      await DatabaseRepository(uid: event.uid).addUserData(
          meal: event.meal,
          product: product,
          amount: product.amount,
          value: product.value);
    });

    yield AddReturnState();
  }
}
