import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/repositories/repositories.dart';
import 'package:lifestylediet/utils/common_utils.dart';

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
  String _currentDate;
  List<Meal> _mealList = [];
  NutrimentsData _nutrimentsData;

  HomeBloc(this.uid, this._currentDate);

  String get meal => _meal;

  String get currentDate => _currentDate;

  List<Meal> get mealList => _mealList;

  List<WeightProgress> get weightProgressList => _weightProgressList;

  PersonalData get personalData => _personalData;

  NutrimentsData get nutrimentsData => _nutrimentsData;

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
    yield HomeLoadingState();
    DatabaseUserRepository _databaseUserRepository =
        DatabaseUserRepository(uid: uid);
    DatabaseRepository _databaseRepository = DatabaseRepository(uid: uid);
    _personalData = await _databaseUserRepository.getUserPersonalData();
    _productList = await _databaseRepository.getUserData();
    _weightProgressList = await _databaseUserRepository.getUserWeightData();
    Utils utils = new Utils();
    _nutrimentsData = utils.getNutrimentsData(_productList);
    await _mealLists(_productList);
    _createMealList();
    yield HomeLoadedState();
  }

  Stream<HomeState> _mapHomeLogout(Logout event) async* {
    yield HomeLoadingState();
    UserRepository _repository = UserRepository();
    await _repository.logout();
    yield HomeLogoutState();
  }

  Stream<HomeState> _mapAddProduct(AddProductScreen event) async* {
    _meal = event.meal;
    _currentDate = event.currentDate;
    yield HomeAddingState(meal, currentDate, uid);
  }

  Stream<HomeState> _mapAddWeight(AddWeight event) async* {
    DateFormat dateFormat = new DateFormat("yyyy-MM-dd");
    String strDate = dateFormat.format(DateTime.now());
    _weightProgressList.removeWhere(
      (element) => strDate == element.date && event.weight != element.weight,
    );
    _personalData.weight = event.weight;
    _weightProgressList.add(WeightProgress(event.weight, strDate));
    DatabaseUserRepository _databaseUserRepository =
        new DatabaseUserRepository(uid: uid);
    await _databaseUserRepository.addUserWeight(weight: event.weight);
    _weightProgressList = await _databaseUserRepository.getUserWeightData();
    yield HomeLoadedState();
  }

  Stream<HomeState> _mapChangePlan(ChangePlan event) async* {
    DatabaseUserRepository _databaseUserRepository =
        new DatabaseUserRepository(uid: uid);
    await _databaseUserRepository.updatePlan(event.plan);
    yield HomeLoadedState();
  }

  Stream<HomeState> _mapDeleteProduct(DeleteProduct event) async* {
    yield HomeLoadingState();
    dispose();
    DatabaseRepository _databaseRepository = DatabaseRepository(uid: uid);
    int index = _productList.indexWhere((product) => product.id == event.id);
    _databaseRepository.deleteProduct(_productList[index]);
    _productList.removeAt(index);
    await _mealLists(_productList);
    yield HomeLoadedState();
  }

  Stream<HomeState> _mapUpdateProduct(UpdateProduct event) async* {
    yield HomeLoadingState();
    dispose();
    DatabaseRepository _databaseRepository = DatabaseRepository(uid: uid);
    _productList = await _databaseRepository.getUserData();
    int index = _productList.indexWhere((product) => product.id == event.id);
    _productList[index].value = event.value;
    _currentDate = _productList[index].date;
    _productList[index].amount = event.amount;
    await _mealLists(_productList);
    await _databaseRepository.updateProduct(_productList[index]);
    yield HomeLoadedState();
  }

  Stream<HomeState> _mapUpdateProfileData(UpdateProfileData event) async* {
    DatabaseUserRepository _databaseUserRepository =
        new DatabaseUserRepository(uid: uid);
    _personalData = event.personalData;
    await _databaseUserRepository.updateProfileData(event.personalData);
    yield HomeLoadedState();
  }

  void _createMealList() {
    Meal breakfast = new Meal("Breakfast", true, _breakfastList);
    Meal dinner = new Meal("Dinner", false, _dinnerList);
    Meal supper = new Meal("Supper", false, _supperList);
    _mealList = [breakfast, dinner, supper];
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
