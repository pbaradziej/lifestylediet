import 'package:flutter/material.dart';
import 'package:lifestylediet/bloc/authBloc/bloc.dart';
import 'package:lifestylediet/components/components.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/utils/common_utils.dart';

class GoalsScreen extends StatefulWidget {
  final AuthBloc bloc;

  const GoalsScreen({Key key, this.bloc}) : super(key: key);

  @override
  _GoalsScreenState createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  TextEditingController _activityController =
      TextEditingController(text: i18n.activityNormal);
  TextEditingController _goalsController =
      TextEditingController(text: i18n.keepWeight);
  TextEditingController _weightController = TextEditingController(text: "");
  TextEditingController _heightController = TextEditingController(text: "");
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
              _goalsForm(node),
            ],
          ),
        ),
      ),
    );
  }

  Form _goalsForm(node) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Text("Goals", style: titleStyle),
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
    );
  }

  Widget _activityDropdownButton() {
    return DropdownComponent(
      controller: _activityController,
      label: "Activity level",
      values: [i18n.activityLow, i18n.activityNormal, i18n.activityHigh],
    );
  }

  Widget _goalsDropdownButton() {
    return DropdownComponent(
      controller: _goalsController,
      label: "Goal",
      values: [i18n.loseWeight, i18n.keepWeight, i18n.gainWeight],
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
        if (_formKey.currentState.validate()) {
          PersonalData personalData = _bloc.personalData;
          personalData.setWeight(_weightController.text);
          personalData.setHeight(_heightController.text);
          personalData.setActivity(_activityController.text);
          personalData.setGoal(_goalsController.text);
          personalData.setImagePath("");

          _bloc.add(GoalsEvent());
        }
      },
    );
  }
}
