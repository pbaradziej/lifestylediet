import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:lifestylediet/models/database_product.dart';
import 'package:lifestylediet/models/nutriments_data.dart';
import 'package:lifestylediet/models/personal_data.dart';
import 'package:lifestylediet/repositories/database_product_repository.dart';
import 'package:lifestylediet/repositories/database_user_repository.dart';
import 'package:lifestylediet/utils/nutriments/nutriments_data_helper.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final DatabaseRepository _databaseRepository;
  final DatabaseUserRepository _databaseUserRepository;

  ProfileCubit()
      : _databaseUserRepository = DatabaseUserRepository(),
        _databaseRepository = DatabaseRepository(),
        super(ProfileState(status: ProfileStatus.loading));

  void updatePersonalData(PersonalData personalData) async {
    await _databaseUserRepository.updateProfileData(personalData);
    final ProfileState updatedState = state.copyWith(personalData: personalData);
    emit(updatedState);
  }

  void initializePersonalData() async {
    final PersonalData personalData = await _databaseUserRepository.getUserPersonalData();
    final List<DatabaseProduct> products = await _databaseRepository.getProducts();
    final NutrimentsData nutrimentsData = NutrimentsDataHelper.getNutrimentsDataList(products);
    final ProfileState state = ProfileState(
      status: ProfileStatus.loaded,
      personalData: personalData,
      nutrimentsData: nutrimentsData,
    );
    emit(state);
  }
}
