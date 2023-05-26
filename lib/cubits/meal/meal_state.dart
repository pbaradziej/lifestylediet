part of 'meal_cubit.dart';

enum MealStatus {
  loading,
  loaded,
}

class MealState extends Equatable {
  final MealStatus status;
  final bool dailyWeightUpdated;
  final PersonalData personalData;

  MealState({
    required this.status,
    this.dailyWeightUpdated = false,
    final PersonalData? personalData,
  }) : personalData = personalData ?? PersonalData();

  MealState copyWith({
    final MealStatus? status,
    final bool? dailyWeightUpdated,
    final PersonalData? personalData,
  }) {
    return MealState(
      status: status ?? this.status,
      dailyWeightUpdated: dailyWeightUpdated ?? this.dailyWeightUpdated,
      personalData: personalData ?? this.personalData,
    );
  }

  @override
  List<Object> get props => <Object>[
        status,
        dailyWeightUpdated,
        personalData,
      ];
}
