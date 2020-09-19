import 'package:bloc/bloc.dart';
import 'package:lifestylediet/food_api/ProductSearch.dart';
import 'package:openfoodfacts/model/Product.dart';

import 'bloc.dart';

class AddBloc extends Bloc<AddEvent, AddState> {
  ProductSearch _product = ProductSearch();

  @override
  AddState get initialState => AddLoadedState();

  @override
  Stream<AddState> mapEventToState(AddEvent event) async* {
    if (event is SearchFood) {
      yield AddLoadingState();
      List<Product> _products = await _product.searchProducts(event.search);
      yield AddSearchState(_products);
    } else if(event is AddReturn) {
      yield AddReturnState();
    }
  }
}
