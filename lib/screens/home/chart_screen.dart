import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/components/components.dart';
import 'package:lifestylediet/cubits/weight/weight_cubit.dart';
import 'package:lifestylediet/models/personal_data.dart';
import 'package:lifestylediet/models/weight_progress.dart';
import 'package:lifestylediet/utils/fonts.dart';

class ChartScreen extends StatefulWidget {
  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  late WeightCubit cubit;
  late TextEditingController weightController;
  late List<WeightProgress> weightProgress;
  late PersonalData personalData;

  @override
  void initState() {
    super.initState();
    cubit = context.read();
    weightController = TextEditingController();
    weightProgress = <WeightProgress>[];
    personalData = PersonalData();
    cubit.initializeWeightData();
  }

  @override
  Widget build(BuildContext context) {
    final WeightState state = context.select<WeightCubit, WeightState>(getWeightState);
    weightProgress = state.weightProgress;
    personalData = state.personalData;
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              weightChart(),
              bmiChart(),
            ],
          ),
        ),
      ],
    );
  }

  WeightState getWeightState(WeightCubit cubit) {
    return cubit.state;
  }

  Widget weightChart() {
    return Card(
      elevation: 2,
      child: Container(
        height: 450,
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        child: Column(
          children: <Widget>[
            summaryHeadLine('Weight chart'),
            const SizedBox(height: 20),
            weightLineChart(),
            const SizedBox(height: 20),
            weightNumericField(),
          ],
        ),
      ),
    );
  }

  Widget weightLineChart() {
    return Expanded(
      child: charts.TimeSeriesChart(
        getSeriesWeightData(),
        animate: true,
        dateTimeFactory: const charts.LocalDateTimeFactory(),
      ),
    );
  }

  List<charts.Series<WeightProgress, DateTime>> getSeriesWeightData() {
    return <charts.Series<WeightProgress, DateTime>>[
      charts.Series<WeightProgress, DateTime>(
        id: 'Weight progress',
        data: weightProgress,
        domainFn: (WeightProgress series, _) => DateTime.parse(series.date),
        measureFn: (WeightProgress series, _) => double.parse(series.weight),
        colorFn: (WeightProgress series, _) => charts.MaterialPalette.blue.shadeDefault,
      )
    ];
  }

  Widget weightNumericField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        NumericComponent(
          controller: weightController,
          label: 'Weight',
          halfScreen: true,
          hintText: 'Add weight...',
          unit: 'kg',
          filled: false,
          textInputAction: TextInputAction.done,
        ),
        SizedBox(
          width: 150,
          child: RaisedButtonComponent(
            label: 'Add weight',
            onPressed: () async {
              final String weight = weightController.text;
              if (weight.isNotEmpty) {
                cubit.addWeight(weight);
              }
            },
            circle: false,
          ),
        ),
      ],
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
          children: <Widget>[
            summaryHeadLine('BMI chart'),
            const SizedBox(height: 20),
            bmiLineChart(),
          ],
        ),
      ),
    );
  }

  Widget summaryHeadLine(String name) {
    return Padding(
      padding: const EdgeInsets.only(left: 18),
      child: Text(name, style: subTitleAddScreenStyle),
    );
  }

  Widget bmiLineChart() {
    return Expanded(
      child: charts.TimeSeriesChart(
        getSeriesBMIData(),
        animate: true,
        dateTimeFactory: const charts.LocalDateTimeFactory(),
      ),
    );
  }

  List<charts.Series<WeightProgress, DateTime>> getSeriesBMIData() {
    return <charts.Series<WeightProgress, DateTime>>[
      charts.Series<WeightProgress, DateTime>(
        id: 'Weight progress',
        data: weightProgress,
        domainFn: (WeightProgress series, _) => DateTime.parse(series.date),
        measureFn: (WeightProgress series, _) => getBMI(series.weight),
        colorFn: (WeightProgress series, _) => charts.MaterialPalette.blue.shadeDefault,
      )
    ];
  }

  double getBMI(String weight) {
    final double weightDouble = double.parse(weight);
    final double bmi = weightDouble / pow(double.parse(personalData.height) / 100, 2);

    return bmi.roundToDouble();
  }
}
