import 'package:bloc/bloc.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/repositories/repositories.dart';
import 'package:lifestylediet/utils/utils.dart';

import 'bloc.dart';

class AddBloc extends Bloc<AddEvent, AddState> {
  final String meal;
  final String currentDate;
  final String uid;
  Utils utils = new Utils();

  AddBloc(this.meal, this.currentDate, this.uid);

  @override
  AddState get initialState => AddLoadedState();

  @override
  Stream<AddState> mapEventToState(AddEvent event) async* {
    if (event is InitialScreen) {
      yield* _mapInitialScreen(event);
    } else if (event is SearchProduct) {
      yield* _mapSearchProduct(event);
    } else if (event is AddReturn) {
      yield* _mapReturn(event);
    } else if (event is AddProduct) {
      yield* _mapAddProduct(event);
    } else if (event is AddProductList) {
      yield* _mapAddProductList(event);
    } else if (event is DatabaseProductList) {
      yield* _mapDatabaseProductList(event);
    }
  }

  Stream<AddState> _mapInitialScreen(InitialScreen event) async* {
    yield AddLoadedState();
  }

  Stream<AddState> _mapSearchProduct(SearchProduct event) async* {
    yield AddLoadingState();
    await Future.delayed(Duration(seconds: 1));
    yield AddLoadedState();
  }

  Stream<AddState> _mapAddProduct(AddProduct event) async* {
    yield AddLoadingState();

    DatabaseProduct product = utils.setProductValues(
        event.product, currentDate, meal, event.amount, event.value);
    await DatabaseRepository(uid: uid).addProduct(product: product);

    yield AddReturnState();
  }

  Stream<AddState> _mapAddProductList(AddProductList event) async* {
    yield AddLoadingState();
    List<DatabaseProduct> products = event.products;
    products.forEach((product) async {
      DatabaseProduct databaseProduct = utils.setProductValues(
          product, currentDate, meal, product.amount, product.value);
      await DatabaseRepository(uid: uid).addProduct(product: databaseProduct);
    });

    yield AddReturnState();
  }

  Stream<AddState> _mapDatabaseProductList(DatabaseProductList event) async* {
    List<DatabaseProduct> _productsList;
    DatabaseLocalRepository databaseLocalRepository =
        new DatabaseLocalRepository(uid: uid);
    _productsList = await databaseLocalRepository.getDatabaseData();
    yield DatabaseProductsState(_productsList);
  }

  Stream<AddState> _mapReturn(AddReturn event) async* {
    yield AddLoadingState();
    yield AddReturnState();
  }
}
