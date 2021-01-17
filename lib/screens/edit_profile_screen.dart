import 'package:flutter/material.dart';

import 'package:lifestylediet/bloc/homeBloc/bloc.dart';
import 'package:lifestylediet/components/components.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/utils/common_utils.dart';

class EditProfileScreen extends StatefulWidget {
  final PersonalData personalData;
  final HomeBloc bloc;

  const EditProfileScreen({
    Key key,
    this.personalData,
    this.bloc,
  }) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  HomeBloc _homeBloc;
  PersonalData _personalData;
  TextEditingController _sexController;
  TextEditingController _dateController;
  TextEditingController _firstNameController;
  TextEditingController _lastNameController;
  TextEditingController _activityController;
  TextEditingController _weightController;
  TextEditingController _heightController;

  @override
  initState() {
    _personalData = widget.personalData;
    _sexController = TextEditingController(text: _personalData.sex);
    _dateController = TextEditingController(text: _personalData.date);
    _firstNameController = TextEditingController(text: _personalData.firstName);
    _lastNameController = TextEditingController(text: _personalData.lastName);
    _activityController = TextEditingController(text: _personalData.activity);
    _weightController = TextEditingController(text: _personalData.weight);
    _heightController = TextEditingController(text: _personalData.height);
    _homeBloc = widget.bloc;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_homeBloc.state is HomeLoadedState) {
      HomeLoadedState state = _homeBloc.state;
      _personalData = state.personalData;
    }
    final node = FocusScope.of(context);
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: appTheme(),
        child: Center(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowGlow();
            },
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Text('Edit Personal Info', style: titleStyle),
                    SizedBox(height: 15),
                    _firstNameField(node),
                    _lastNameField(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _birthdayDateComponent(),
                        _sexDropdownButton(),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _weightField(node),
                        _heightField(),
                      ],
                    ),
                    _activityDropdownButton(),
                    SizedBox(height: 10),
                    _saveButton(),
                    SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _firstNameField(node) {
    return TextFormFieldComponent(
      controller: _firstNameController,
      label: "Firstname",
      onEditingComplete: () => node.nextFocus(),
      hintText: "Enter Firstname...",
    );
  }

  Widget _lastNameField() {
    return TextFormFieldComponent(
      controller: _lastNameController,
      label: "Lastname",
      hintText: "Enter Lastname...",
      textInputAction: TextInputAction.done,
    );
  }

  Widget _birthdayDateComponent() {
    return DateTimeFieldComponent(
      controller: _dateController,
      label: "Birthday",
      hintText: "Enter date...",
      halfScreen: true,
    );
  }

  Widget _sexDropdownButton() {
    return DropdownComponent(
      controller: _sexController,
      label: "Sex",
      halfScreen: true,
      values: ["Male", "Female"],
    );
  }

  Widget _saveButton() {
    return RaisedButtonComponent(
      label: "Save",
      onPressed: () {
        PersonalData personalData = new PersonalData(
          _sexController.text,
          _weightController.text,
          _heightController.text,
          _dateController.text,
          _firstNameController.text,
          _lastNameController.text,
          _activityController.text,
          _personalData.goal,
        );
        _homeBloc.add(UpdateProfileData(personalData: personalData));
        setState(() {});
        Navigator.of(context).pop();
      },
    );
  }

  Widget _activityDropdownButton() {
    return DropdownComponent(
      controller: _activityController,
      label: "Poziom aktywności",
      values: [
        "Tryb życia siedzący",
        "Tryb życia średnia aktywność",
        "Tryb życia wysoka aktywność"
      ],
    );
  }

  Widget _weightField(node) {
    return NumericComponent(
      initialValue: _weightController.text,
      controller: _weightController,
      label: "Weight",
      halfScreen: true,
      unit: "kg",
      onEditingComplete: () => node.nextFocus(),
    );
  }

  Widget _heightField() {
    return NumericComponent(
      initialValue: _heightController.text,
      controller: _heightController,
      label: "Height",
      halfScreen: true,
      unit: "cm",
      textInputAction: TextInputAction.done,
    );
  }
}
