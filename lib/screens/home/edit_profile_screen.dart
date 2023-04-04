import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/components/components.dart';
import 'package:lifestylediet/cubits/profile/profile_cubit.dart';
import 'package:lifestylediet/models/personal_data.dart';
import 'package:lifestylediet/utils/fonts.dart';
import 'package:lifestylediet/utils/i18n.dart';
import 'package:lifestylediet/utils/theme.dart';

class EditProfileScreen extends StatefulWidget {
  final PersonalData personalData;

  const EditProfileScreen({
    required this.personalData,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late ProfileCubit profileCubit;
  late PersonalData personalData;
  late TextEditingController sexController;
  late TextEditingController dateController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController activityController;
  late TextEditingController weightController;
  late TextEditingController heightController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    profileCubit = context.read();
    personalData = widget.personalData;
    sexController = getTextEditingController(personalData.sex);
    dateController = getTextEditingController(personalData.date);
    firstNameController = getTextEditingController(personalData.firstName);
    lastNameController = getTextEditingController(personalData.lastName);
    activityController = getTextEditingController(personalData.activity);
    weightController = getTextEditingController(personalData.weight);
    heightController = getTextEditingController(personalData.height);
  }

  @override
  Widget build(BuildContext context) {
    final FocusScopeNode node = FocusScope.of(context);
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: appTheme(),
        child: Center(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowIndicator();
              return false;
            },
            child: ListView(
              children: <Widget>[
                Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20),
                      Text('Edit Personal Info', style: titleStyle),
                      const SizedBox(height: 15),
                      firstNameField(node),
                      lastNameField(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          birthdayDateComponent(),
                          sexDropdownButton(),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          weightField(node),
                          heightField(),
                        ],
                      ),
                      activityDropdownButton(),
                      const SizedBox(height: 10),
                      saveButton(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextEditingController getTextEditingController(String text) {
    return TextEditingController(text: text);
  }

  Widget firstNameField(FocusNode node) {
    return TextFormFieldComponent(
      controller: firstNameController,
      label: 'Firstname',
      onEditingComplete: () => node.nextFocus(),
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

  Widget weightField(FocusNode node) {
    return NumericComponent(
      initialValue: weightController.text,
      controller: weightController,
      label: 'Weight',
      halfScreen: true,
      unit: 'kg',
      onEditingComplete: () => node.nextFocus(),
    );
  }

  Widget heightField() {
    return NumericComponent(
      initialValue: heightController.text,
      controller: heightController,
      label: 'Height',
      halfScreen: true,
      unit: 'cm',
      textInputAction: TextInputAction.done,
    );
  }

  Widget saveButton() {
    return RaisedButtonComponent(
      label: 'Save',
      onPressed: onPressed,
    );
  }

  void onPressed() {
    final FormState? currentState = formKey.currentState;
    final bool hasNoErrors = currentState?.validate() ?? false;
    if (hasNoErrors) {
      updatePersonalData();
      Navigator.of(context).pop();
    }
  }

  void updatePersonalData() {
    final PersonalData updatedPersonalData = personalData.copyWith(
      sex: sexController.text,
      weight: weightController.text,
      height: heightController.text,
      date: dateController.text,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      activity: activityController.text,
    );
    profileCubit.updatePersonalData(updatedPersonalData);
  }
}
