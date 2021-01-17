import 'package:bloc/bloc.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/repositories/repositories.dart';
import 'bloc.dart';
import 'package:intl/intl.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  UserRepository _repository = UserRepository();
  String _meal;
  List<DatabaseProduct> productList;
  List<DatabaseProduct> breakfastList = [];
  List<DatabaseProduct> dinnerList = [];
  List<DatabaseProduct> supperList = [];
  PersonalData _personalData;
  List<WeightProgress> _weightProgressList = [];
  Nutrition _nutrition;
  String _currentDate;
  String uid;
  List<Meal> mealList = [];
  NutrimentsData _averageNutrition;

  String get meal => _meal;

  String get currentDate => _currentDate;

  Nutrition get nutrition => getNutrition(_personalData);

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
    }
  }

  Stream<HomeState> _mapHomeLoad(HomeLoad event) async* {
    uid = event.uid;
    yield HomeLoadingState();
    DatabaseRepository _databaseRepository = DatabaseRepository(uid: event.uid);
    _personalData = await _databaseRepository.getUserPersonalData();
    productList = await _databaseRepository.getUserData();
    _weightProgressList = await _databaseRepository.getUserWeightData();
    _nutrition = getNutrition(_personalData);
    _averageNutrition = getAverageNutrition(productList);
    await mealLists(productList);
    List<Meal> mealList = createMealList();
    yield HomeLoadedState(
      mealList,
      _nutrition,
      _personalData,
      _weightProgressList,
      _averageNutrition,
    );
  }

  Stream<HomeState> _mapHomeLogout(Logout event) async* {
    yield HomeLoadingState();
    await _repository.logout();
    yield HomeLogoutState();
  }

  Stream<HomeState> _mapAddProduct(AddProductScreen event) async* {
    _meal = event.meal;
    _currentDate = event.currentDate;
    yield HomeAddingState();
  }

  Stream<HomeState> _mapAddWeight(AddWeight event) async* {
    DateFormat dateFormat = new DateFormat("yyyy-MM-dd");
    String strDate = dateFormat.format(DateTime.now());
    _weightProgressList.removeWhere(
      (element) => strDate == element.date && event.weight != element.weight,
    );
    _personalData.weight = event.weight;
    _weightProgressList.add(WeightProgress(event.weight, strDate));
    DatabaseRepository _databaseRepository = new DatabaseRepository(uid: uid);
    await _databaseRepository.addUserWeight(weight: event.weight);
    _weightProgressList = await _databaseRepository.getUserWeightData();
    yield HomeLoadedState(
      mealList,
      _nutrition,
      _personalData,
      _weightProgressList,
      _averageNutrition,
    );
  }

  Stream<HomeState> _mapChangePlan(ChangePlan event) async* {
    DatabaseRepository _databaseRepository = new DatabaseRepository(uid: uid);
    await _databaseRepository.updatePlan(event.plan);
    yield HomeLoadedState(
      mealList,
      _nutrition,
      _personalData,
      _weightProgressList,
      _averageNutrition,
    );
  }

  Stream<HomeState> _mapDeleteProduct(DeleteProduct event) async* {
    yield HomeLoadingState();
    dispose();
    DatabaseRepository _databaseRepository = DatabaseRepository(uid: uid);
    int index = productList.indexWhere((product) => product.id == event.id);
    _databaseRepository.deleteProduct(productList[index]);
    productList.removeAt(index);
    _nutrition = getNutrition(_personalData);
    await mealLists(productList);
    yield HomeLoadedState(
      mealList,
      _nutrition,
      _personalData,
      _weightProgressList,
      _averageNutrition,
    );
  }

  Stream<HomeState> _mapUpdateProduct(UpdateProduct event) async* {
    yield HomeLoadingState();
    dispose();
    DatabaseRepository _databaseRepository = DatabaseRepository(uid: uid);
    productList = await _databaseRepository.getUserData();
    int index = productList.indexWhere((product) => product.id == event.id);
    productList[index].value = event.value;
    productList[index].amount = event.amount;
    _nutrition = getNutrition(_personalData);
    await mealLists(productList);
    await _databaseRepository.updateProduct(productList[index]);
    yield HomeLoadedState(
      mealList,
      _nutrition,
      _personalData,
      _weightProgressList,
      _averageNutrition,
    );
  }

  Stream<HomeState> _mapUpdateProfileData(UpdateProfileData event) async* {
    DatabaseRepository _databaseRepository = DatabaseRepository(uid: uid);
    _personalData = event.personalData;
    await _databaseRepository.updateProfileData(event.personalData);
    yield HomeLoadedState(
      mealList,
      _nutrition,
      _personalData,
      _weightProgressList,
      _averageNutrition,
    );
  }

  NutrimentsData getAverageNutrition(List<DatabaseProduct> productList) {
    List<NutrimentsData> nutrimentDataList = getNutrimentDataList();
    double calories = 0;
    double carbs = 0;
    double fiber = 0;
    double sugars = 0;
    double protein = 0;
    double fats = 0;
    double saturatedFats = 0;
    double cholesterol = 0;
    double sodium = 0;
    double potassium = 0;
    for (NutrimentsData nutrimentsData in nutrimentDataList) {
      calories += nutrimentsData.calories;
      carbs += nutrimentsData.carbs;
      fiber += nutrimentsData.fiber;
      sugars += nutrimentsData.sugars;
      protein += nutrimentsData.protein;
      fats += nutrimentsData.fats;
      saturatedFats += nutrimentsData.saturatedFats;
      cholesterol += nutrimentsData.cholesterol;
      sodium += nutrimentsData.sodium;
      potassium += nutrimentsData.potassium;
    }
    return new NutrimentsData(
      calories / nutrimentDataList.length,
      carbs / nutrimentDataList.length,
      fiber / nutrimentDataList.length,
      sugars / nutrimentDataList.length,
      protein / nutrimentDataList.length,
      fats / nutrimentDataList.length,
      saturatedFats / nutrimentDataList.length,
      cholesterol / nutrimentDataList.length,
      sodium / nutrimentDataList.length,
      potassium / nutrimentDataList.length,
    );
  }

  getNutrimentDataList() {
    List<NutrimentsData> nutrimentDataList = [];
    for (int i = 0; i < 7; i++) {
      double calories = 0;
      double carbs = 0;
      double fiber = 0;
      double sugars = 0;
      double protein = 0;
      double fats = 0;
      double saturatedFats = 0;
      double cholesterol = 0;
      double sodium = 0;
      double potassium = 0;
      for (DatabaseProduct product in productList) {
        DateFormat dateFormat = new DateFormat("yyyy-MM-dd");
        String strDate =
            dateFormat.format(DateTime.now().subtract(Duration(days: i)));
        Nutriments nutriments = product.nutriments;
        if (product.date == strDate) {
          if (product.value == "serving") {
            calories += nutriments.caloriesPerServing * product.amount;
            carbs += nutriments.carbsPerServing * product.amount;
            fiber += nutriments.fiberPerServing * product.amount;
            sugars += nutriments.sugarsPerServing * product.amount;
            protein += nutriments.proteinPerServing * product.amount;
            fats += nutriments.fatsPerServing * product.amount;
            saturatedFats +=
                nutriments.saturatedFatsPerServing * product.amount;
            cholesterol += nutriments.cholesterolPerServing * product.amount;
            sodium += nutriments.sodiumPerServing * product.amount;
            potassium += nutriments.potassiumPerServing * product.amount;
          } else {
            calories += nutriments.caloriesPer100g * product.amount;
            carbs += nutriments.carbs * product.amount;
            fiber += nutriments.fiber * product.amount;
            sugars += nutriments.sugars * product.amount;
            protein += nutriments.protein * product.amount;
            fats += nutriments.fats * product.amount;
            saturatedFats += nutriments.saturatedFats * product.amount;
            cholesterol += nutriments.cholesterol * product.amount;
            sodium += nutriments.sodium * product.amount;
            potassium += nutriments.potassium * product.amount;
          }
        }
      }
      if (calories != 0.0)
        nutrimentDataList.add(new NutrimentsData(
          calories,
          carbs,
          fiber,
          sugars,
          protein,
          fats,
          saturatedFats,
          cholesterol,
          sodium,
          potassium,
        ));
    }

    return nutrimentDataList;
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

  void dispose() {
    breakfastList.clear();
    dinnerList.clear();
    supperList.clear();
  }

  void disposeWeight() {
    _weightProgressList.clear();
  }

  Nutrition getNutrition(PersonalData personalData) {
    double kcalIntake;
    double weight = double.parse(personalData.weight);
    double height = double.parse(personalData.height);
    double age = (DateTime.now().year - DateTime.parse(personalData.date).year)
        .toDouble();
    switch (personalData.sex) {
      case ('Male'):
        kcalIntake = 10 * weight + 6.25 * height - 5 * age + 5;
        break;
      case ('Female'):
        kcalIntake = 10 * weight + 6.25 * height - 5 * age - 161;
        break;
    }
    kcalIntake *= getPalParameter(personalData);
    kcalIntake *= getPhysicalParameter(personalData);
    double protein = (kcalIntake.round() * 0.25) / 4;
    double carbs = (kcalIntake.round() * 0.60) / 4;
    double fats = (kcalIntake.round() * 0.15) / 9;
    return Nutrition(
      kcalIntake.round(),
      0,
      0,
      fats.round(),
      protein.round(),
      carbs.round(),
    );
  }

  double getPalParameter(PersonalData personalData) {
    switch (personalData.activity) {
      case "Tryb życia siedzący":
        return 1.5;
      case "Tryb życia średnia aktywność":
        return 1.8;
      case "Tryb życia wysoka aktywność":
        return 2.2;
      default:
        return 1.8;
    }
  }

  double getPhysicalParameter(PersonalData personalData) {
    switch (personalData.goal) {
      case "Schudnąć":
        return 0.9;
      case "Utrzymać wagę":
        return 1.0;
      case "Przytyć":
        return 1.1;
      default:
        return 1.0;
    }
  }
}
