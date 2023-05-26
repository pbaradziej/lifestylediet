part of 'profile_cubit.dart';

enum ProfileStatus {
  loading,
  loaded,
}

class ProfileState extends Equatable {
  final ProfileStatus status;
  final PersonalData personalData;
  final NutrimentsData nutrimentsData;
  final Key key;

  ProfileState({
    required this.status,
    final PersonalData? personalData,
    final NutrimentsData? nutrimentsData,
  })  : personalData = personalData ?? PersonalData(),
        nutrimentsData = nutrimentsData ?? NutrimentsData.empty(),
        key = UniqueKey();

  ProfileState copyWith({
    final ProfileStatus? status,
    final PersonalData? personalData,
    final NutrimentsData? nutrimentsData,
  }) {
    return ProfileState(
      status: status ?? this.status,
      personalData: personalData ?? this.personalData,
      nutrimentsData: nutrimentsData ?? this.nutrimentsData,
    );
  }

  @override
  List<Object> get props => <Object>[
        status,
        personalData,
        nutrimentsData,
        key,
      ];
}
