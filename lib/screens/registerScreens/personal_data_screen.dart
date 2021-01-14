import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifestylediet/components/components.dart';
import 'package:lifestylediet/utils/common_utils.dart';

class PersonalDataScreen extends StatefulWidget {
  final String email;
  final String password;

  const PersonalDataScreen({
    Key key,
    this.email,
    this.password,
  }) : super(key: key);

  @override
  _PersonalDataScreenState createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  DateTime selectedDate = DateTime.now();
  TextEditingController _sexController = TextEditingController(text: "Male");
  TextEditingController _weightController = TextEditingController(text: "");
  TextEditingController _heightController = TextEditingController(text: "");
  TextEditingController _dateController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  Text('Personal Info', style: titleStyle),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _firstNameField(),
                      _lastNameField(),
                    ],
                  ),
                  SizedBox(height: 10),
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
                      _weightField(),
                      _heightField(),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _firstNameField() {
    return TextFormFieldComponent(
      controller: _firstNameController,
      label: "Firstname",
      hintText: "Enter Firstname...",
      halfScreen: true,
    );
  }

  Widget _lastNameField() {
    return TextFormFieldComponent(
      controller: _lastNameController,
      label: "Lastname",
      hintText: "Enter Lastname...",
      halfScreen: true,
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

  Widget _weightField() {
    return NumericComponent(
      controller: _weightController,
      label: "Weight",
      halfScreen: true,
      unit: "kg",
    );
  }

  Widget _heightField() {
    return NumericComponent(
      controller: _heightController,
      label: "Height",
      halfScreen: true,
      unit: "cm",
    );
  }
}
