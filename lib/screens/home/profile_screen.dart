import 'dart:io';
import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lifestylediet/cubits/auth/auth_cubit.dart';
import 'package:lifestylediet/cubits/profile/profile_cubit.dart';
import 'package:lifestylediet/enums/settings_menu.dart';
import 'package:lifestylediet/models/kcal_data.dart';
import 'package:lifestylediet/models/nutriments_data.dart';
import 'package:lifestylediet/models/personal_data.dart';
import 'package:lifestylediet/screens/home/edit_profile_screen.dart';
import 'package:lifestylediet/screens/loading_screens.dart';
import 'package:lifestylediet/styles/app_text_styles.dart';
import 'package:lifestylediet/utils/fonts.dart';
import 'package:lifestylediet/utils/i18n.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late AuthCubit authCubit;
  late ProfileCubit cubit;
  late ImagePicker imagePicker;
  late PersonalData personalData;
  late NutrimentsData nutrimentsData;

  @override
  void initState() {
    super.initState();
    authCubit = context.read();
    cubit = context.read();
    imagePicker = ImagePicker();
    cubit.initializePersonalData();
  }

  @override
  Widget build(BuildContext context) {
    final ProfileState state = context.select<ProfileCubit, ProfileState>(getProfileState);
    personalData = state.personalData;
    nutrimentsData = state.nutrimentsData;
    if (state.status == ProfileStatus.loading) {
      return loadingScreen();
    }

    return profile();
  }

  ProfileState getProfileState(ProfileCubit cubit) {
    return cubit.state;
  }

  Widget profile() {
    return ListView(
      children: <Widget>[
        SizedBox(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              profileData(),
              summaryPersonalData(),
              summaryNutritionCard(),
            ],
          ),
        ),
      ],
    );
  }

  Widget profileData() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Flexible(flex: 2, child: circleAvatar()),
            Flexible(flex: 3, child: nameSign()),
            Flexible(child: settingsButton()),
          ],
        ),
      ),
    );
  }

  Widget circleAvatar() {
    final String firstName = personalData.firstName;
    return CircleAvatar(
      backgroundColor: Colors.grey,
      radius: 50.0,
      child: personalData.imagePath != ''
          ? ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.file(
                File(personalData.imagePath),
                width: 100,
                height: 100,
                fit: BoxFit.fitHeight,
              ),
            )
          : Text(firstName[0]),
    );
  }

  Widget nameSign() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 10),
          child: Text(
            'Hello,',
            style: AppTextStyle.titleLarge(context),
          ),
        ),
        Text(
          '${personalData.firstName} ${personalData.lastName}',
          style: AppTextStyle.titleMedium(context),
        ),
      ],
    );
  }

  Widget settingsButton() {
    return PopupMenuButton<SettingsMenu>(
      onSelected: settingsMenu,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<SettingsMenu>>[
        const PopupMenuItem<SettingsMenu>(
          value: SettingsMenu.changePlan,
          child: Text('Change Plan'),
        ),
        const PopupMenuItem<SettingsMenu>(
          value: SettingsMenu.addProfilePicture,
          child: Text('Add profile picture'),
        ),
        const PopupMenuItem<SettingsMenu>(
          value: SettingsMenu.changeProfileData,
          child: Text('Change Profile'),
        ),
        const PopupMenuItem<SettingsMenu>(
          value: SettingsMenu.logout,
          child: Text('Logout'),
        ),
      ],
      icon: const Icon(
        Icons.settings,
        color: Colors.black54,
      ),
    );
  }

  void settingsMenu(SettingsMenu result) {
    switch (result) {
      case SettingsMenu.changePlan:
        alertDialog(context);
        break;
      case SettingsMenu.addProfilePicture:
        showPicker(context);
        break;
      case SettingsMenu.changeProfileData:
        Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: builder,
          ),
        );
        break;
      case SettingsMenu.logout:
        authCubit.logout();
        break;
    }
  }

  Widget builder(BuildContext context) {
    return BlocProvider<ProfileCubit>.value(
      value: cubit,
      child: EditProfileScreen(personalData: personalData),
    );
  }

  void alertDialog(BuildContext context) {
    final List<String> plans = <String>[I18n.loseWeight, I18n.keepWeight, I18n.gainWeight];
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Plan'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: getPlans(plans, context),
              ),
            ),
          ),
        );
      },
    );
  }

  List<RadioListTile<String>> getPlans(List<String> plans, BuildContext context) {
    return <RadioListTile<String>>[
      for (final String plan in plans)
        RadioListTile<String>(
          title: Text(plan),
          value: plan,
          groupValue: personalData.goal,
          selected: personalData.goal == plan,
          onChanged: (String? value) => onChanged(value, context),
        )
    ];
  }

  void onChanged(String? value, BuildContext context) {
    if (value != personalData.goal && value != null) {
      final PersonalData updatedPersonalData = personalData.copyWith(goal: value);
      cubit.updatePersonalData(updatedPersonalData);
      Navigator.of(context).pop();
    }
  }

  void showPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Photo Library'),
                  onTap: () async {
                    await imgFromGallery();
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () async {
                    await imgFromCamera();
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> imgFromCamera() async {
    const ImageSource source = ImageSource.camera;
    await updatePersonalDataImage(source);
  }

  Future<void> imgFromGallery() async {
    const ImageSource source = ImageSource.gallery;
    await updatePersonalDataImage(source);
  }

  Future<void> updatePersonalDataImage(ImageSource source) async {
    final XFile? image = await imagePicker.pickImage(source: source, imageQuality: 50);
    final String path = image?.path ?? '';
    final PersonalData updatedPersonalData = personalData.copyWith(imagePath: path);
    cubit.updatePersonalData(updatedPersonalData);
  }

  Widget summaryPersonalData() {
    return Card(
      elevation: 2,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            summaryHeadLine('Summary'),
            personalDataCard(),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget summaryNutritionCard() {
    final double calories = nutrimentsData.calories;
    if (calories.toString() != 'NaN') {
      return Card(
        elevation: 2,
        child: SizedBox(
          height: 600,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              summaryHeadLine('Average caloric intake'),
              const SizedBox(height: 15),
              pieCaloriesChart(),
              personalBodyStatistics(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    }

    return const SizedBox();
  }

  Widget pieCaloriesChart() {
    return Expanded(
      child: charts.PieChart<String>(
        getSeriesData(),
        animate: true,
        defaultRenderer: charts.ArcRendererConfig<String>(
          arcWidth: 90,
          arcRendererDecorators: <charts.ArcLabelDecorator<String>>[
            charts.ArcLabelDecorator<String>(
              labelPosition: charts.ArcLabelPosition.inside,
              insideLabelStyleSpec: charts.TextStyleSpec(fontSize: 16, color: charts.Color.fromHex(code: '#FFFFFF')),
            )
          ],
        ),
      ),
    );
  }

  Widget summaryHeadLine(String name) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, top: 10.0),
      child: Text(name, style: subTitleAddScreenStyle),
    );
  }

  Widget personalDataCard() {
    final double bmi = double.parse(personalData.weight) / pow(double.parse(personalData.height) / 100, 2);
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 26, right: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          summaryRow('Weight', '${personalData.weight} kg'),
          summaryRow('Height', '${personalData.height} cm'),
          summaryRow('Sex', '${personalData.sex}'),
          summaryRow('Birth date', '${personalData.date}'),
          summaryRow('Activity level', '${personalData.activity}'),
          summaryRow('Goal', '${personalData.goal}'),
          summaryRow('BMI', '${bmi.toStringAsFixed(2).toString()}'),
          checkBMI(bmi),
        ],
      ),
    );
  }

  Widget checkBMI(double bmi) {
    if (bmi >= 25) {
      return Text(I18n.highBMI, softWrap: true, style: orangeProfileTextStyle);
    } else if (bmi < 25 && bmi > 18.5) {
      return Text(I18n.normalBMI, softWrap: true, style: greenProfileTextStyle);
    } else {
      return Text(I18n.lowBMI, softWrap: true, style: orangeProfileTextStyle);
    }
  }

  Widget personalBodyStatistics() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 26, right: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          summaryCaloriesRow('Kcal', nutrimentsData.calories),
          summaryCaloriesRow('Protein', nutrimentsData.protein),
          summaryCaloriesRow('Carbs', nutrimentsData.carbs, padding: 0),
          summaryCaloriesRow('Fiber', nutrimentsData.fiber, style: const TextStyle(), padding: 0),
          summaryCaloriesRow('Sugars', nutrimentsData.sugars, style: const TextStyle()),
          summaryCaloriesRow('Fats', nutrimentsData.fats, padding: 0),
          summaryCaloriesRow('Saturated fats', nutrimentsData.saturatedFats, style: const TextStyle()),
          summaryCaloriesRow('Cholesterol', nutrimentsData.cholesterol),
          summaryCaloriesRow('Sodium', nutrimentsData.sodium),
          summaryCaloriesRow('Potassium', nutrimentsData.potassium),
        ],
      ),
    );
  }

  Widget summaryRow(String name, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              name,
              style: defaultProfileTextStyle,
              softWrap: true,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: defaultProfileTextStyle,
              softWrap: true,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget summaryCaloriesRow(
    String name,
    double value, {
    TextStyle? style,
    double? padding,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: padding ?? 7.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              name,
              style: style ?? defaultProfileTextStyle,
              softWrap: true,
            ),
          ),
          Flexible(
            child: Text(
              value.toStringAsFixed(2).toString(),
              style: style ?? defaultProfileTextStyle,
              softWrap: true,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  List<charts.Series<KcalData, String>> getSeriesData() {
    final List<KcalData> data = <KcalData>[
      KcalData(
        nutrition: 'Protein',
        value: nutrimentsData.protein,
      ),
      KcalData(
        nutrition: 'Carbs',
        value: nutrimentsData.carbs,
      ),
      KcalData(
        nutrition: 'Fats',
        value: nutrimentsData.fats,
      ),
    ];

    return <charts.Series<KcalData, String>>[
      charts.Series<KcalData, String>(
        id: 'Nutrition',
        data: data,
        labelAccessorFn: (KcalData row, _) => '${row.nutrition}:\n${row.value.toStringAsFixed(2).toString()}',
        domainFn: (KcalData grades, _) => grades.nutrition,
        measureFn: (KcalData grades, _) => (grades.value).floorToDouble(),
      )
    ];
  }
}
