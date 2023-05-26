import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/components/components.dart';
import 'package:lifestylediet/cubits/login/login_cubit.dart';
import 'package:lifestylediet/models/personal_data.dart';
import 'package:lifestylediet/utils/fonts.dart';
import 'package:lifestylediet/utils/i18n.dart';
import 'package:lifestylediet/utils/theme.dart';

class GoalsScreen extends StatefulWidget {
  final PersonalData personalData;

  const GoalsScreen({
    required this.personalData,
  });

  @override
  _GoalsScreenState createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  late LoginCubit loginCubit;
  late TextEditingController activityController;
  late TextEditingController goalsController;
  late TextEditingController weightController;
  late TextEditingController heightController;
  late GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    loginCubit = context.read();
    activityController = TextEditingController(text: I18n.activityNormal);
    goalsController = TextEditingController(text: I18n.keepWeight);
    weightController = TextEditingController(text: '');
    heightController = TextEditingController(text: '');
    formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(final BuildContext context) {
    final FocusScopeNode node = FocusScope.of(context);
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: appTheme(),
      child: Center(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (final OverscrollIndicatorNotification overscroll) {
            overscroll.disallowIndicator();
            return false;
          },
          child: ListView(
            children: <Widget>[
              goalsForm(node),
            ],
          ),
        ),
      ),
    );
  }

  Form goalsForm(final FocusScopeNode node) {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          Text('Goals', style: titleStyle),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              weightField(node),
              heightField(),
            ],
          ),
          activityDropdownButton(),
          goalsDropdownButton(),
          const SizedBox(height: 20),
          doneButton(),
        ],
      ),
    );
  }

  Widget weightField(final FocusScopeNode node) {
    return NumericComponent(
      controller: weightController,
      label: 'Weight',
      halfScreen: true,
      unit: 'kg',
      onEditingComplete: node.nextFocus,
    );
  }

  Widget heightField() {
    return NumericComponent(
      controller: heightController,
      label: 'Height',
      halfScreen: true,
      unit: 'cm',
      textInputAction: TextInputAction.done,
    );
  }

  Widget activityDropdownButton() {
    return DropdownComponent(
      controller: activityController,
      label: 'Activity level',
      values: <String>[
        I18n.activityLow,
        I18n.activityNormal,
        I18n.activityHigh,
      ],
    );
  }

  Widget goalsDropdownButton() {
    return DropdownComponent(
      controller: goalsController,
      label: 'Goal',
      values: <String>[
        I18n.loseWeight,
        I18n.keepWeight,
        I18n.gainWeight,
      ],
    );
  }

  Widget doneButton() {
    return RaisedButtonComponent(
      label: 'Done',
      onPressed: onPressed,
    );
  }

  void onPressed() {
    final FormState? currentState = formKey.currentState;
    final bool hasNoErrors = currentState?.validate() ?? false;
    if (hasNoErrors) {
      loginToApplication();
    }
  }

  void loginToApplication() {
    final PersonalData personalData = widget.personalData;
    final PersonalData updatedPersonalData = personalData.copyWith(
      weight: weightController.text,
      height: heightController.text,
      activity: activityController.text,
      goal: goalsController.text,
    );

    loginCubit.authenticateData(updatedPersonalData);
  }
}
