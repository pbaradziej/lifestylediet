import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/bloc/homeBloc/bloc.dart';
import 'package:lifestylediet/bloc/loginBloc/bloc.dart';

import 'package:lifestylediet/utils/theme.dart';

class ChartScreen extends StatefulWidget {
  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  HomeBloc _homeBloc;
  LoginBloc _loginBloc;

  @override
  initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _homeBloc = BlocProvider.of<HomeBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                weightChart(),
                bmiChart(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget weightChart() {
    return Card(
      elevation: 2,
      child: Container(
        height: 300,
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            summaryHeadLine("Wykres Wagi"),
            SizedBox(height: 20),
            weightLineChart(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget weightLineChart() {
    return Expanded(
      child: new charts.LineChart(
        _getSeriesData(),
        animate: true,
      ),
    );
  }

  Widget bmiChart() {
    return Card(
      elevation: 2,
      child: Container(
        height: 300,
        width: double.infinity,
        padding: const EdgeInsets.all(15),
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
      child: new charts.LineChart(
        _getSeriesData(),
        animate: true,
      ),
    );
  }

  Widget summaryHeadLine(String name) {
    return Padding(
      padding: const EdgeInsets.only(left: 18),
      child: Text(name, style: subTitleAddScreenStyle),
    );
  }

  final data = [
    new SalesData(0, 1500000),
    new SalesData(1, 1735000),
    new SalesData(2, 1678000),
    new SalesData(3, 1890000),
    new SalesData(4, 1907000),
  ];

  _getSeriesData() {
    List<charts.Series<SalesData, int>> series = [
      charts.Series(
          id: "Sales",
          data: data,
          domainFn: (SalesData series, _) => series.year,
          measureFn: (SalesData series, _) => series.sales,
          colorFn: (SalesData series, _) =>
              charts.MaterialPalette.blue.shadeDefault)
    ];
    return series;
  }
}

class SalesData {
  final int year;
  final int sales;

  SalesData(this.year, this.sales);
}
