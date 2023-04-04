import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:lifestylediet/models/personal_data.dart';
import 'package:lifestylediet/models/weight_progress.dart';
import 'package:lifestylediet/repositories/database_user_repository.dart';

part 'weight_state.dart';

class WeightCubit extends Cubit<WeightState> {
  final DatabaseUserRepository _databaseUserRepository;

  WeightCubit()
      : _databaseUserRepository = DatabaseUserRepository(),
        super(WeightState());

  void initializeWeightData() async {
    final List<WeightProgress> weightProgress = await _databaseUserRepository.getUserWeightData();
    final PersonalData personalData = await _databaseUserRepository.getUserPersonalData();
    final WeightState state = WeightState(
      weightProgress: weightProgress,
      personalData: personalData,
    );
    emit(state);
  }

  void addWeight(String weight) async {
    await _databaseUserRepository.addUserWeight(weight: weight);
    final List<WeightProgress> weightProgress = await _databaseUserRepository.getUserWeightData();
    final PersonalData personalData = state.personalData;
    final PersonalData updatedPersonalData = personalData.copyWith(weight: weight);
    final WeightState updatedState = state.copyWith(
      weightProgress: weightProgress,
      personalData: updatedPersonalData,
    );
    emit(updatedState);
  }
}
