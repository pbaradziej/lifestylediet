import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/components/components.dart';
import 'package:lifestylediet/cubits/login/login_cubit.dart';
import 'package:lifestylediet/models/personal_data.dart';
import 'package:lifestylediet/utils/fonts.dart';
import 'package:lifestylediet/utils/theme.dart';

class PersonalDataScreen extends StatefulWidget {
  @override
  _PersonalDataScreenState createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  late LoginCubit loginCubit;
  late DateTime selectedDate;
  late TextEditingController sexController;
  late TextEditingController dateController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    loginCubit = context.read();
    selectedDate = DateTime.now();
    sexController = TextEditingController(text: 'Male');
    dateController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
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
              personalDataForm(node),
            ],
          ),
        ),
      ),
    );
  }

  Form personalDataForm(final FocusScopeNode node) {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          Text('Personal Info', style: titleStyle),
          const SizedBox(height: 30),
          firstNameField(node),
          lastNameField(),
          personalInformationFields(),
          const SizedBox(height: 10),
          nextButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget firstNameField(final FocusScopeNode node) {
    return TextFormFieldComponent(
      controller: firstNameController,
      label: 'Firstname',
      onEditingComplete: node.nextFocus,
      hintText: 'Enter Firstname...',
    );
  }

  Widget lastNameField() {
    return TextFormFieldComponent(
      controller: lastNameController,
      label: 'Lastname',
      hintText: 'Enter Lastname...',
      textInputAction: TextInputAction.done,
    );
  }

  Widget personalInformationFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        birthdayDateComponent(),
        sexDropdownButton(),
      ],
    );
  }

  Widget birthdayDateComponent() {
    return DateTimeFieldComponent(
      controller: dateController,
      label: 'Birthday',
      hintText: 'Enter date...',
      halfScreen: true,
    );
  }

  Widget sexDropdownButton() {
    return DropdownComponent(
      controller: sexController,
      label: 'Sex',
      halfScreen: true,
      values: <String>[
        'Male',
        'Female',
      ],
    );
  }

  Widget nextButton() {
    return RaisedButtonComponent(
      label: 'Next',
      onPressed: onPressed,
    );
  }

  void onPressed() {
    final FormState? currentState = formKey.currentState;
    final bool hasNoErrors = currentState?.validate() ?? false;
    if (hasNoErrors) {
      showGoalsAuthenticationScreen();
    }
  }

  void showGoalsAuthenticationScreen() {
    final PersonalData personalData = PersonalData(
      sex: sexController.text,
      date: dateController.text,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
    );

    loginCubit.showGoalsAuthenticationScreen(personalData);
  }
}
