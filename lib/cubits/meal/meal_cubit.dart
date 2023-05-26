import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:lifestylediet/models/personal_data.dart';
import 'package:lifestylediet/models/weight_progress.dart';
import 'package:lifestylediet/repositories/database_user_repository.dart';

part 'meal_state.dart';

class MealCubit extends Cubit<MealState> {
  final DatabaseUserRepository _databaseUserRepository;

  MealCubit()
      : _databaseUserRepository = DatabaseUserRepository(),
        super(MealState(status: MealStatus.loading));

  Future<void> initializeMealsData() async {
    final bool dailyWeightUpdated = await _wasDailyWeightUpdated();
    final PersonalData personalData = await _databaseUserRepository.getUserPersonalData();
    _emitMealState(dailyWeightUpdated, personalData);
  }

  void updateDailyWeight() {
    final MealState updatedState = state.copyWith(dailyWeightUpdated: true);
    emit(updatedState);
  }

  Future<bool> _wasDailyWeightUpdated() async {
    final List<WeightProgress> weightProgress = await _databaseUserRepository.getUserWeightData();
    return weightProgress.any(_containsTodayDate);
  }

  bool _containsTodayDate(final WeightProgress weight) {
    final String date = weight.date;
    final String dateNow = _getTodayDate();

    return date.contains(dateNow);
  }

  String _getTodayDate() {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final DateTime dateTime = DateTime.now();

    return dateFormat.format(dateTime);
  }

  void _emitMealState(final bool dailyWeightUpdated, final PersonalData personalData) {
    final MealState state = MealState(
      status: MealStatus.loaded,
      dailyWeightUpdated: dailyWeightUpdated,
      personalData: personalData,
    );
    emit(state);
  }
}
