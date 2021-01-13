import 'package:bloc/bloc.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/repositories/repositories.dart';
import 'bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  UserRepository _repository = UserRepository();
  String _meal;
  List<DatabaseProduct> productList;
  List<DatabaseProduct> breakfastList = [];
  List<DatabaseProduct> dinnerList = [];
  List<DatabaseProduct> supperList = [];
  Nutrition _nutrition = Nutrition(2500, 0, 0, 0, 0, 0);
  String uid;
  List<Meal> mealList = [];

  String get meal => _meal;

  @override
  HomeState get initialState => HomeLoadingState();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is HomeLoad) {
      yield* _mapHomeLoad(event);
    } else if (event is Logout) {
      yield* _mapHomeLogout(event);
    } else if (event is AddProductScreen) {
      yield* _mapAddProduct(event);
    } else if (event is DeleteProduct) {
      yield* _mapDeleteProduct(event);
    } else if (event is UpdateProduct) {
      yield* _mapUpdateProduct(event);
    }
  }

  Stream<HomeState> _mapHomeLoad(HomeLoad event) async* {
    uid = event.uid;
    yield HomeLoadingState();
    DatabaseRepository _databaseRepository = DatabaseRepository();
    _databaseRepository = DatabaseRepository(uid: event.uid);
    productList = await _databaseRepository.getUserData();
    await mealLists(productList);
    List<Meal> mealList = createMealList();
    yield HomeLoadedState(mealList, _nutrition);
    }

  Stream<HomeState> _mapHomeLogout(Logout event) async* {
    yield HomeLoadingState();
    await _repository.logout();
    yield HomeLogoutState();
  }

  Stream<HomeState> _mapAddProduct(AddProductScreen event) async* {
    _meal = event.meal;
    yield HomeAddingState();
  }

  Stream<HomeState> _mapDeleteProduct(DeleteProduct event) async* {
    yield HomeLoadingState();
    dispose();
    DatabaseRepository _databaseRepository = DatabaseRepository(uid: uid);
    int index = productList.indexWhere((product) => product.id == event.id);
    _databaseRepository.deleteProduct(productList[index]);
    productList.removeAt(index);
    await mealLists(productList);
    yield HomeLoadedState(mealList, _nutrition);
  }

  Stream<HomeState> _mapUpdateProduct(UpdateProduct event) async* {
    yield HomeLoadingState();
    dispose();
    DatabaseRepository _databaseRepository = DatabaseRepository(uid: uid);
    productList = await _databaseRepository.getUserData();
    int index = productList.indexWhere((product) => product.id == event.id);
    productList[index].value = event.value;
    productList[index].amount = event.amount;
    await mealLists(productList);
    _databaseRepository.updateProduct(productList[index]);
    yield HomeLoadedState(mealList, _nutrition);
  }

  List<Meal> createMealList() {
    Meal breakfast = new Meal("Breakfast", true, breakfastList);
    Meal dinner = new Meal("Dinner", false, dinnerList);
    Meal supper = new Meal("Supper", false, supperList);
    mealList = [breakfast, dinner, supper];
    return mealList;
  }

  mealLists(List<DatabaseProduct> productList) {
    for (DatabaseProduct product in productList) {
      kcalAmount(product);
      switch (product.meal) {
        case 'Breakfast':
          breakfastList.add(product);
          break;
        case 'Dinner':
          dinnerList.add(product);
          break;
        case 'Supper':
          supperList.add(product);
          break;
      }
    }
  }

  kcalAmount(DatabaseProduct product) {
    Nutriments nutriments = product.nutriments;
    _nutrition.kcal += valueOfNutriment(
        nutriments.caloriesPer100g, nutriments.caloriesPerServing, product);
    _nutrition.protein += valueOfNutriment(
        nutriments.protein, nutriments.proteinPerServing, product);
    _nutrition.carbs +=
        valueOfNutriment(nutriments.carbs, nutriments.carbsPerServing, product);
    _nutrition.fats +=
        valueOfNutriment(nutriments.fats, nutriments.fatsPerServing, product);
  }

  valueOfNutriment(double value, double valuePerServing,
      DatabaseProduct product) {
    double val;
    switch (product.value) {
      case 'serving':
        if (valuePerServing == null) return 0;
        val = valuePerServing * product.amount;
        break;
      case '100g':
        if (value == null) return 0;
        val = value * product.amount;
        break;
    }
    return val.toInt();
  }

  void dispose() {
    breakfastList.clear();
    dinnerList.clear();
    supperList.clear();
    _nutrition = Nutrition(2500, 0, 0, 0, 0, 0);
  }
}
