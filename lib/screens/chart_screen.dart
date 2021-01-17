import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/bloc/homeBloc/bloc.dart';
import 'package:lifestylediet/components/components.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/utils/theme.dart';

class ChartScreen extends StatefulWidget {
  final List<WeightProgress> weightProgressList;
  final PersonalData personalData;

  const ChartScreen({
    Key key,
    this.weightProgressList,
    this.personalData,
  }) : super(key: key);

  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  HomeBloc _homeBloc;
  TextEditingController _weightController = new TextEditingController();
  List<WeightProgress> _weightProgressList;
  PersonalData _personalData;

  @override
  initState() {
    super.initState();
    _weightProgressList = widget.weightProgressList;
    _personalData = widget.personalData;
    _homeBloc = BlocProvider.of<HomeBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_homeBloc.state is HomeLoadedState) {
      HomeLoadedState state = _homeBloc.state;
      _personalData = state.personalData;
      _weightProgressList = state.weightProgress;
    }
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              weightChart(),
              bmiChart(),
            ],
          ),
        ),
      ],
    );
  }

  Widget weightChart() {
    return Card(
      elevation: 2,
      child: Container(
        height: 450,
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            summaryHeadLine("Wykres Wagi"),
            SizedBox(height: 20),
            weightLineChart(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NumericComponent(
                  controller: _weightController,
                  label: "Waga",
                  halfScreen: true,
                  unit: "kg",
                  filled: false,
                  textInputAction: TextInputAction.done,
                ),
                Container(
                  width: 150,
                  child: RaisedButtonComponent(
                    label: "Dodaj Wagę",
                    onPressed: () async {
                      if (_weightController.text.isNotEmpty) {
                        _homeBloc.add(AddWeight(_weightController.text));
                        setState(() {});
                      }
                    },
                    circle: false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget weightLineChart() {
    return Expanded(
      child: new charts.TimeSeriesChart(
        _getSeriesWeightData(),
        animate: true,
        dateTimeFactory: const charts.LocalDateTimeFactory(),
      ),
    );
  }

  Widget bmiChart() {
    return Card(
      elevation: 2,
      child: Container(
        height: 300,
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            summaryHeadLine("Wykres BMI"),
            SizedBox(height: 20),
            bmiLineChart(),
          ],
        ),
      ),
    );
  }

  Widget bmiLineChart() {
    return Expanded(
      child: new charts.TimeSeriesChart(
        _getSeriesBMIData(),
        animate: true,
        dateTimeFactory: const charts.LocalDateTimeFactory(),
      ),
    );
  }

  Widget summaryHeadLine(String name) {
    return Padding(
      padding: const EdgeInsets.only(left: 18),
      child: Text(name, style: subTitleAddScreenStyle),
    );
  }

  _getSeriesWeightData() {
    List<charts.Series<WeightProgress, DateTime>> series = [
      charts.Series(
          id: "Weight progress",
          data: _weightProgressList,
          domainFn: (WeightProgress series, _) => DateTime.parse(series.date),
          measureFn: (WeightProgress series, _) => double.parse(series.weight),
          colorFn: (WeightProgress series, _) =>
              charts.MaterialPalette.blue.shadeDefault)
    ];
    return series;
  }

  _getSeriesBMIData() {
    List<charts.Series<WeightProgress, DateTime>> series = [
      charts.Series(
          id: "Weight progress",
          data: _weightProgressList,
          domainFn: (WeightProgress series, _) => DateTime.parse(series.date),
          measureFn: (WeightProgress series, _) => getBMI(series.weight),
          colorFn: (WeightProgress series, _) =>
              charts.MaterialPalette.blue.shadeDefault)
    ];
    return series;
  }

  double getBMI(String weight) {
    double weightDouble = double.parse(weight);
    double bmi =
        weightDouble / pow(double.parse(_personalData.height) / 100, 2);

    return bmi.roundToDouble();
  }
}
