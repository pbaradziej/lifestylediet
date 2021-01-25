import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/bloc/homeBloc/bloc.dart';
import 'package:lifestylediet/components/components.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/utils/common_utils.dart';

class ChartScreen extends StatefulWidget {
  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  HomeBloc _homeBloc;
  TextEditingController _weightController = new TextEditingController();
  List<WeightProgress> _weightProgressList;

  @override
  initState() {
    super.initState();
    _homeBloc = BlocProvider.of<HomeBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    _weightProgressList = _homeBloc.weightProgressList;
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _weightChart(),
              _bmiChart(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _weightChart() {
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
            _summaryHeadLine("Wykres Wagi"),
            SizedBox(height: 20),
            _weightLineChart(),
            SizedBox(height: 20),
            _addWeight(),
          ],
        ),
      ),
    );
  }

  Widget _addWeight() {
    return Row(
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
    );
  }

  Widget _weightLineChart() {
    return Expanded(
      child: new charts.TimeSeriesChart(
        _getSeriesWeightData(),
        animate: true,
        dateTimeFactory: const charts.LocalDateTimeFactory(),
      ),
    );
  }

  Widget _bmiChart() {
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
            _summaryHeadLine("Wykres BMI"),
            SizedBox(height: 20),
            _bmiLineChart(),
          ],
        ),
      ),
    );
  }

  Widget _bmiLineChart() {
    return Expanded(
      child: new charts.TimeSeriesChart(
        _getSeriesBMIData(),
        animate: true,
        dateTimeFactory: const charts.LocalDateTimeFactory(),
      ),
    );
  }

  Widget _summaryHeadLine(String name) {
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
          measureFn: (WeightProgress series, _) => _getBMI(series.weight),
          colorFn: (WeightProgress series, _) =>
              charts.MaterialPalette.blue.shadeDefault)
    ];
    return series;
  }

  double _getBMI(String weight) {
    PersonalData personalData = _homeBloc.personalData;
    double weightDouble = double.parse(weight);
    double bmi = weightDouble / pow(double.parse(personalData.height) / 100, 2);

    return bmi.roundToDouble();
  }
}
