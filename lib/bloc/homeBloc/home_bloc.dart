import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/repositories/repositories.dart';
import 'package:lifestylediet/utils/common_utils.dart';
import 'package:uuid/uuid.dart';

import 'bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final String uid;
  String _meal;
  List<DatabaseProduct> _productList = [];
  List<DatabaseProduct> _breakfastList = [];
  List<DatabaseProduct> _dinnerList = [];
  List<DatabaseProduct> _supperList = [];
  List<WeightProgress> _weightProgressList = [];
  PersonalData _personalData;
  bool _dailyWeightUpdated;
  String _currentDate;
  List<Meal> _mealList = [];
  NutrimentsData _nutrimentsData;
  List<RecipeMeal> _recipes;
  DateFormat _dateFormat = new DateFormat("yyyy-MM-dd");
  String _strDate;
  Utils utils = new Utils();

  HomeBloc(this.uid, this._currentDate);

  DatabaseUserRepository _databaseUserRepository;
  DatabaseRepository _databaseRepository;
  RecipeRepository _recipeRepository;
  UserRepository _repository;

  String get meal => _meal;

  String get currentDate => _currentDate;

  List<Meal> get mealList => _mealList;

  bool get dailyWeightUpdated => _dailyWeightUpdated;

  set dailyWeightUpdated(bool dailyWeightUpdated) {
    this._dailyWeightUpdated = dailyWeightUpdated;
  }

  List<WeightProgress> get weightProgressList => _weightProgressList;

  PersonalData get personalData => _personalData;

  NutrimentsData get nutrimentsData => _nutrimentsData;

  List<RecipeMeal> get recipes => _recipes;

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
    } else if (event is AddWeight) {
      yield* _mapAddWeight(event);
    } else if (event is ChangePlan) {
      yield* _mapChangePlan(event);
    } else if (event is UpdateProfileData) {
      yield* _mapUpdateProfileData(event);
    } else if (event is SearchRecipes) {
      yield* _mapRecipeList(event);
    } else if (event is AddRecipeProduct) {
      yield* _mapAddRecipeProduct(event);
    } else if(event is SaveImage) {
      yield* _mapSaveImage(event);
    }
  }

  Stream<HomeState> _mapHomeLoad(HomeLoad event) async* {
    yield HomeLoadingState();

    yield* _initializeUserData();
    yield* _initializeProductData();
    yield* _initializeRecipeData();

    yield HomeLoadedState();
  }

  Stream<HomeState> _initializeUserData() async* {
    _databaseUserRepository = DatabaseUserRepository(uid: uid);
    _personalData = await _databaseUserRepository.getUserPersonalData();
    _weightProgressList = await _databaseUserRepository.getUserWeightData();
    _checkWeight(_weightProgressList);
  }

  Stream<HomeState> _initializeProductData() async* {
    _databaseRepository = DatabaseRepository(uid: uid);
    _productList = await _databaseRepository.getProducts();
    _nutrimentsData = utils.getNutrimentsData(_productList);
    await _mealLists(_productList);
    _createMealList();
  }

  Stream<HomeState> _initializeRecipeData() async* {
    _recipeRepository = new RecipeRepository();
    _recipes = await _recipeRepository.getInitialRecipes();
  }

  Stream<HomeState> _mapHomeLogout(Logout event) async* {
    yield HomeLoadingState();
    _repository = UserRepository();
    await _repository.logout();
    yield HomeLogoutState();
  }

  Stream<HomeState> _mapAddProduct(AddProductScreen event) async* {
    _meal = event.meal;
    _currentDate = event.currentDate;
    yield HomeAddingState(meal, currentDate, uid);
  }

  Stream<HomeState> _mapAddWeight(AddWeight event) async* {
    _strDate = _dateFormat.format(DateTime.now());
    _weightProgressList.removeWhere(
      (element) => _strDate == element.date && event.weight != element.weight,
    );
    _personalData.weight = event.weight;
    _weightProgressList.add(WeightProgress(event.weight, _strDate));
    DatabaseUserRepository _databaseUserRepository =
        new DatabaseUserRepository(uid: uid);
    await _databaseUserRepository.addUserWeight(weight: event.weight);
    _weightProgressList = await _databaseUserRepository.getUserWeightData();
    yield HomeLoadedState();
  }

  Stream<HomeState> _mapChangePlan(ChangePlan event) async* {
    await _databaseUserRepository.updatePlan(event.plan);
    yield HomeLoadedState();
  }

  Stream<HomeState> _mapDeleteProduct(DeleteProduct event) async* {
    yield HomeLoadingState();
    dispose();
    int index = _productList.indexWhere((product) => product.id == event.id);
    _databaseRepository.deleteProduct(_productList[index]);
    _productList.removeAt(index);
    await _mealLists(_productList);
    yield HomeLoadedState();
  }

  Stream<HomeState> _mapUpdateProduct(UpdateProduct event) async* {
    yield HomeLoadingState();
    dispose();
    _productList = await _databaseRepository.getProducts();
    int index = _productList.indexWhere((product) => product.id == event.id);
    _productList[index].value = event.value;
    _currentDate = _productList[index].date;
    _productList[index].amount = event.amount;
    await _mealLists(_productList);
    await _databaseRepository.updateProduct(_productList[index]);
    yield HomeLoadedState();
  }

  Stream<HomeState> _mapUpdateProfileData(UpdateProfileData event) async* {
    _personalData = event.personalData;
    await _databaseUserRepository.updateProfileData(event.personalData);
    yield HomeLoadedState();
  }

  Stream<HomeState> _mapRecipeList(SearchRecipes event) async* {
    _recipes = await _recipeRepository.getRecipes(event.search);
    yield HomeLoadedState();
  }

  Stream<HomeState> _mapSaveImage(SaveImage event) async* {
    await _databaseUserRepository.updateImage(event.imagePath);
    yield HomeLoadedState();
  }

  Stream<HomeState> _mapAddRecipeProduct(AddRecipeProduct event) async* {
    _strDate = _dateFormat.format(DateTime.now());
    String uuid = Uuid().v4().toString();
    DatabaseProduct product = new DatabaseProduct(
        uuid,
        _strDate,
        event.meal,
        double.parse(event.amount),
        event.recipe.recipeInformation.image,
        event.recipe.recipeInformation.title,
        'serving',
        '',
        _getNutriments(event));
    _mealProduct(product);
    _createMealList();

    await DatabaseRepository(uid: uid).addProduct(product: product);

    yield HomeLoadedState();
  }

  void _checkWeight(List<WeightProgress> weightList) {
    _strDate = _dateFormat.format(DateTime.now());
    _dailyWeightUpdated =
        weightList.map((weight) => weight.date).contains(_strDate);
  }

  Nutriments _getNutriments(AddRecipeProduct event) {
    return new Nutriments(
        0,
        double.parse(event.recipe.recipeNutrition.calories),
        0,
        double.parse(event.recipe.recipeNutrition.carbs.replaceAll('g', '')),
        0,
        0,
        0,
        0,
        0,
        double.parse(event.recipe.recipeNutrition.protein.replaceAll('g', '')),
        0,
        double.parse(event.recipe.recipeNutrition.fat.replaceAll('g', '')),
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0);
  }

  void _createMealList() {
    Meal breakfast = new Meal("Breakfast", true, _breakfastList);
    Meal dinner = new Meal("Dinner", false, _dinnerList);
    Meal supper = new Meal("Supper", false, _supperList);
    _mealList = [breakfast, dinner, supper];
  }

  _mealProduct(DatabaseProduct product) {
    switch (product.meal) {
      case 'Breakfast':
        _breakfastList.add(product);
        break;
      case 'Dinner':
        _dinnerList.add(product);
        break;
      case 'Supper':
        _supperList.add(product);
        break;
    }
  }

  _mealLists(List<DatabaseProduct> productList) {
    for (DatabaseProduct product in productList) {
      switch (product.meal) {
        case 'Breakfast':
          _breakfastList.add(product);
          break;
        case 'Dinner':
          _dinnerList.add(product);
          break;
        case 'Supper':
          _supperList.add(product);
          break;
      }
    }
  }

  void dispose() {
    _breakfastList.clear();
    _dinnerList.clear();
    _supperList.clear();
  }
}
