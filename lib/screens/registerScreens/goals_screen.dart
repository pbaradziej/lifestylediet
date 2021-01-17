import 'package:flutter/material.dart';
import 'package:lifestylediet/bloc/registerBloc/bloc.dart';
import 'package:lifestylediet/components/components.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/utils/common_utils.dart';

class GoalsScreen extends StatefulWidget {
  final String email;
  final String password;
  final String sex;
  final String weight;
  final String height;
  final String date;
  final String firstName;
  final String lastName;
  final RegisterBloc bloc;

  const GoalsScreen({
    Key key,
    this.email,
    this.password,
    this.sex,
    this.weight,
    this.height,
    this.date,
    this.firstName,
    this.lastName,
    this.bloc,
  }) : super(key: key);

  @override
  _GoalsScreenState createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  TextEditingController _activityController =
      TextEditingController(text: "Tryb życia średnia aktywność");
  TextEditingController _goalsController =
      TextEditingController(text: "Utrzymać wagę");
  TextEditingController _weightController = TextEditingController(text: "");
  TextEditingController _heightController = TextEditingController(text: "");
  RegisterBloc _bloc;

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Text('Goals', style: titleStyle),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _weightField(node),
                      _heightField(),
                    ],
                  ),
                  _activityDropdownButton(),
                  _goalsDropdownButton(),
                  SizedBox(height: 20),
                  _doneButton(),
                ],
              ),
            ],
          ),
        ),
      ),
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

  Widget _goalsDropdownButton() {
    return DropdownComponent(
      controller: _goalsController,
      label: "Cel",
      values: ["Schudnąć", "Utrzymać wagę", "Przytyć"],
    );
  }

  Widget _weightField(node) {
    return NumericComponent(
      controller: _weightController,
      label: "Weight",
      halfScreen: true,
      unit: "kg",
      onEditingComplete: () => node.nextFocus(),
    );
  }

  Widget _heightField() {
    return NumericComponent(
      controller: _heightController,
      label: "Height",
      halfScreen: true,
      unit: "cm",
      textInputAction: TextInputAction.done,
    );
  }

  Widget _doneButton() {
    return RaisedButtonComponent(
      label: "Done",
      onPressed: () {
        PersonalData personalData = new PersonalData(
          widget.sex,
          _weightController.text,
          _heightController.text,
          widget.date,
          widget.firstName,
          widget.lastName,
          _activityController.text,
          _goalsController.text,
        );
        _bloc.add(GoalsEvent(
            email: widget.email,
            password: widget.password,
            personalData: personalData));
      },
    );
  }
}
