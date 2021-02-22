import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifestylediet/bloc/authBloc/bloc.dart';
import 'package:lifestylediet/components/components.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/utils/common_utils.dart';

class PersonalDataScreen extends StatefulWidget {
  final AuthBloc bloc;

  const PersonalDataScreen({Key key, this.bloc}) : super(key: key);

  @override
  _PersonalDataScreenState createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  DateTime selectedDate = DateTime.now();
  TextEditingController _sexController = TextEditingController(text: "Male");
  TextEditingController _dateController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  AuthBloc _bloc;
  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    _bloc = widget.bloc;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
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
              _personalDataForm(node),
            ],
          ),
        ),
      ),
    );
  }

  Form _personalDataForm(node) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Text('Personal Info', style: titleStyle),
          SizedBox(height: 30),
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
          _nextButton(),
          SizedBox(height: 20),
        ],
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

  Widget _nextButton() {
    return RaisedButtonComponent(
      label: "Next",
      onPressed: () {
        if (_formKey.currentState.validate()) {
          PersonalData personalData = _bloc.personalData;
          personalData.setSex(_sexController.text);
          personalData.setDate(_dateController.text);
          personalData.setFirstName(_firstNameController.text);
          personalData.setLastName(_lastNameController.text);

          _bloc.add(PersonalDataEvent());
        }
      },
    );
  }
}
