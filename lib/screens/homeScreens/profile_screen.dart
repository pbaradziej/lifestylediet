import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/bloc/homeBloc/bloc.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/screens/screens.dart';
import 'package:lifestylediet/utils/common_utils.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  HomeBloc _homeBloc;
  PersonalData _personalData;
  NutrimentsData _nutrimentsData;

  @override
  initState() {
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _personalData = _homeBloc.personalData;
    _nutrimentsData = _homeBloc.nutrimentsData;
    return ListView(
      children: [
        SizedBox(
          width: double.infinity,
          child: Column(
            children: [
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
          children: [
            Flexible(flex: 2, child: circleAvatar()),
            Flexible(flex: 3, child: nameSign()),
            Flexible(flex: 1, child: settingsButton()),
          ],
        ),
      ),
    );
  }

  Widget circleAvatar() {
    return CircleAvatar(
      backgroundColor: Colors.grey,
      radius: 50.0,
      child: Text("P"),
    );
  }

  Widget nameSign() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 10),
          child: Text(
            "Hello",
            style: Theme.of(context).textTheme.title,
          ),
        ),
        Text(
          _personalData.firstName + " " + _personalData.lastName,
          style: Theme.of(context).textTheme.subhead,
        ),
      ],
    );
  }

  Widget settingsButton() {
    return PopupMenuButton<Settings>(
      onSelected: (Settings result) {
        settingsMenu(result);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Settings>>[
        const PopupMenuItem<Settings>(
          value: Settings.changePlan,
          child: Text('Change Plan'),
        ),
        const PopupMenuItem<Settings>(
          value: Settings.changeProfileData,
          child: Text('Change Profile'),
        ),
        const PopupMenuItem<Settings>(
          value: Settings.logout,
          child: Text('Logout'),
        ),
      ],
      icon: Icon(Icons.settings, color: Colors.black54),
    );
  }

  // ignore: missing_return
  settingsMenu(Settings result) {
    switch (result) {
      case Settings.changePlan:
        return alertDialog(context);
        break;
      case Settings.changeProfileData:
        return Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditProfileScreen(bloc: _homeBloc),
          ),
        );
        break;
      case Settings.logout:
        _homeBloc.add(Logout());
        break;
    }
  }

  Future alertDialog(BuildContext context) {
    List<String> plans = ["Lose weight", "Keep weight", "Gain weight"];
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Select Plan"),
            content: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: plans
                      .map((e) => RadioListTile(
                            title: Text(e),
                            value: e,
                            groupValue: _personalData.goal,
                            selected: _personalData.goal == e,
                            onChanged: (value) {
                              if (value != _personalData.goal) {
                                _personalData.goal = value;
                                _homeBloc.add(ChangePlan(_personalData.goal));
                                setState(() {});
                                Navigator.of(context).pop();
                              }
                            },
                          ))
                      .toList(),
                ),
              ),
            ),
          );
        });
  }

  Widget summaryPersonalData() {
    return Card(
      elevation: 2,
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            summaryHeadLine("Summary"),
            personalData(),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget summaryNutritionCard() {
    if (_nutrimentsData.calories.toString() != "NaN") {
      return Card(
        elevation: 2,
        child: Container(
          height: 600,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              summaryHeadLine("Average caloric intake"),
              SizedBox(height: 15),
              pieCaloriesChart(),
              personalBodyStatistics(),
              SizedBox(height: 20),
            ],
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }

  Widget pieCaloriesChart() {
    return Expanded(
      child: new charts.PieChart(
        _getSeriesData(),
        animate: true,
        defaultRenderer:
            new charts.ArcRendererConfig(arcWidth: 90, arcRendererDecorators: [
          new charts.ArcLabelDecorator(
              labelPosition: charts.ArcLabelPosition.inside,
              insideLabelStyleSpec: new charts.TextStyleSpec(
                  fontSize: 16, color: charts.Color.fromHex(code: "#FFFFFF")))
        ]),
      ),
    );
  }

  Widget summaryHeadLine(String name) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, top: 10.0),
      child: Text(name, style: subTitleAddScreenStyle),
    );
  }

  Widget personalData() {
    double bmi = double.parse(_personalData.weight) /
        pow(double.parse(_personalData.height) / 100, 2);
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 26, right: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          summaryRow("Weight", "${_personalData.weight} kg"),
          summaryRow("Height", "${_personalData.height} cm"),
          summaryRow("Sex", "${_personalData.sex}"),
          summaryRow("Birth date", "${_personalData.date}"),
          summaryRow("Activity level", "${_personalData.activity}"),
          summaryRow("Goal", "${_personalData.goal}"),
          summaryRow("BMI", "${bmi.toStringAsFixed(2).toString()}"),
          checkBMI(bmi),
        ],
      ),
    );
  }

  Widget checkBMI(double bmi) {
    if (bmi >= 25) {
      return Text(
          "Your BMI is slightly to high. Keep up a good work and you will get to your goal in no time.",
          softWrap: true,
          style: orangeProfileTextStyle);
    } else if (bmi < 25 && bmi > 18.5) {
      return Text(
          "Your BMI is correct. Keep up a good work, you are doing great.",
          softWrap: true,
          style: greenProfileTextStyle);
    } else {
      return Text(
          "Your BMI is slightly to low. Keep up a good work and you will get to your goal in no time.",
          softWrap: true,
          style: orangeProfileTextStyle);
    }
  }

  Widget personalBodyStatistics() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 26, right: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          summaryCaloriesRow("Kcal", _nutrimentsData.calories),
          summaryCaloriesRow("Protein", _nutrimentsData.protein),
          summaryCaloriesRow("Carbs", _nutrimentsData.carbs, padding: 0),
          summaryCaloriesRow("Fiber", _nutrimentsData.fiber,
              style: TextStyle(), padding: 0),
          summaryCaloriesRow("Sugars", _nutrimentsData.sugars,
              style: TextStyle()),
          summaryCaloriesRow("Fats", _nutrimentsData.fats, padding: 0),
          summaryCaloriesRow("Saturated fats", _nutrimentsData.saturatedFats,
              style: TextStyle()),
          summaryCaloriesRow("Cholesterol", _nutrimentsData.cholesterol),
          summaryCaloriesRow("Sodium", _nutrimentsData.sodium),
          summaryCaloriesRow("Potassium", _nutrimentsData.potassium),
        ],
      ),
    );
  }

  Widget summaryRow(
    String name,
    String value, {
    TextStyle style,
    double padding,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: padding ?? 7.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: Text(
              name,
              style: style ?? defaultProfileTextStyle,
              softWrap: true,
            ),
          ),
          Flexible(
            flex: 1,
            child: Text(
              value,
              style: style ?? defaultProfileTextStyle,
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
    TextStyle style,
    double padding,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: padding ?? 7.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: Text(
              name,
              style: style ?? defaultProfileTextStyle,
              softWrap: true,
            ),
          ),
          Flexible(
            flex: 1,
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

  _getSeriesData() {
    final data = [
      KcalData('Protein', _nutrimentsData.protein),
      KcalData('Carbs', _nutrimentsData.carbs),
      KcalData('Fats', _nutrimentsData.fats),
    ];
    List<charts.Series<KcalData, String>> series = [
      charts.Series(
          id: "Nutrition",
          data: data,
          labelAccessorFn: (KcalData row, _) =>
              '${row.nutrition}:\n${row.value.toStringAsFixed(2).toString()}',
          domainFn: (KcalData grades, _) => grades.nutrition,
          measureFn: (KcalData grades, _) => (grades.value).floorToDouble())
    ];
    return series;
  }
}

class KcalData {
  final String nutrition;
  final double value;

  KcalData(this.nutrition, this.value);
}

enum Settings { changeProfileData, changePlan, logout }
