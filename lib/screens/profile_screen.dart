import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lifestylediet/bloc/homeBloc/bloc.dart';
import 'package:lifestylediet/utils/common_utils.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  HomeBloc _homeBloc;

  @override
  initState() {
    super.initState();
    _homeBloc = BlocProvider.of<HomeBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
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
            "Witaj",
            style: Theme.of(context).textTheme.title,
          ),
        ),
        Text(
          "Paweł Baradziej",
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

   void settingsMenu(Settings result) {
      switch (result) {
        case Settings.changePlan:
          break;
        case Settings.changeProfileData:
          break;
        case Settings.logout:
          _homeBloc.add(Logout());
          break;
      }
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
            summaryHeadLine("Podsumowanie"),
            personalData(),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget summaryNutritionCard() {
    return Card(
      elevation: 2,
      child: Container(
        height: 600,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            summaryHeadLine("Średnie spożycie kaloryczne"),
            SizedBox(height: 15),
            pieCaloriesChart(),
            personalBodyStatistics(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget pieCaloriesChart() {
    return Expanded(
      child: new charts.PieChart(
        _getSeriesData(),
        animate: true,
        defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: 60,
            arcRendererDecorators: [new charts.ArcLabelDecorator()]),
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
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 26, right: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          summaryRow("Waga", "85 kg"),
          summaryRow("BMI", "23"),
          summaryRow("Wzrost", "188 cm"),
        ],
      ),
    );
  }

  Widget personalBodyStatistics() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 26, right: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          summaryRow("Kcal", "0"),
          summaryRow("Protein", "0"),
          summaryRow("Carbs", "0", padding: 0),
          summaryRow("Fiber", "0", style: TextStyle(), padding: 0),
          summaryRow("Sugars", "0", style: TextStyle()),
          summaryRow("Fats", "0", padding: 0),
          summaryRow("Saturated fats", "0", style: TextStyle()),
          summaryRow("Cholesterol", "0"),
          summaryRow("Sodium", "0"),
          summaryRow("Potassium", "0"),
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
      padding: EdgeInsets.only(bottom: padding ?? 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: style ?? defaultProfileTextStyle),
          Text(value, style: style ?? defaultProfileTextStyle),
        ],
      ),
    );
  }

  final data = [
    GradesData('A', 190),
    GradesData('B', 230),
    GradesData('C', 150),
    GradesData('D', 73),
    GradesData('E', 31),
    GradesData('Fail', 13),
  ];

  _getSeriesData() {
    List<charts.Series<GradesData, String>> series = [
      charts.Series(
          id: "Grades",
          data: data,
          labelAccessorFn: (GradesData row, _) =>
              '${row.gradeSymbol}: ${row.numberOfStudents}',
          domainFn: (GradesData grades, _) => grades.gradeSymbol,
          measureFn: (GradesData grades, _) => grades.numberOfStudents)
    ];
    return series;
  }
}

class GradesData {
  final String gradeSymbol;
  final int numberOfStudents;

  GradesData(this.gradeSymbol, this.numberOfStudents);
}

enum Settings { changeProfileData, changePlan, logout }
