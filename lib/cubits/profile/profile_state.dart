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
    PersonalData? personalData,
    NutrimentsData? nutrimentsData,
  })  : personalData = personalData ?? PersonalData(),
        nutrimentsData = nutrimentsData ?? NutrimentsData.empty(),
        key = UniqueKey();

  ProfileState copyWith({
    ProfileStatus? status,
    PersonalData? personalData,
    NutrimentsData? nutrimentsData,
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
