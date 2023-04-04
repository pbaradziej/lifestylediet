part of 'weight_cubit.dart';

class WeightState extends Equatable {
  final List<WeightProgress> weightProgress;
  final PersonalData personalData;
  final Key key;

  WeightState({
    PersonalData? personalData,
    this.weightProgress = const <WeightProgress>[],
  })  : personalData = personalData ?? PersonalData(),
        key = UniqueKey();

  WeightState copyWith({
    List<WeightProgress>? weightProgress,
    PersonalData? personalData,
  }) {
    return WeightState(
      weightProgress: weightProgress ?? this.weightProgress,
      personalData: personalData ?? this.personalData,
    );
  }

  @override
  List<Object> get props => <Object>[
        weightProgress,
        personalData,
        key,
      ];
}
