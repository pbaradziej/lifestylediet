import 'dart:io';
import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lifestylediet/bloc/homeBloc/bloc.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/screens/screens.dart';
import 'package:lifestylediet/utils/common_utils.dart';
import 'package:lifestylediet/utils/i18n.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  HomeBloc _homeBloc;
  PersonalData _personalData;
  NutrimentsData _nutrimentsData;
  ImagePicker _imagePicker = new ImagePicker();

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
              _profileData(),
              _summaryPersonalData(),
              _summaryNutritionCard(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _profileData() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(flex: 2, child: _circleAvatar()),
            Flexible(flex: 3, child: _nameSign()),
            Flexible(flex: 1, child: _settingsButton()),
          ],
        ),
      ),
    );
  }

  Widget _circleAvatar() {
    File image;
    if(_personalData.imagePath != "") {
      image = File(_personalData.imagePath);
    }
    return CircleAvatar(
      backgroundColor: Colors.grey,
      radius: 50.0,
      child: _personalData.imagePath != ""
          ? ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Image.file(
          image,
          width: 100,
          height: 100,
          fit: BoxFit.fitHeight,
        ),
      )
          : Text(_personalData.firstName[0]),
    );
  }

  Widget _nameSign() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 10),
          child: Text(
            "Hello",
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Text(
          _personalData.firstName + " " + _personalData.lastName,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ],
    );
  }

  Widget _settingsButton() {
    return PopupMenuButton<Settings>(
      onSelected: (Settings result) {
        _settingsMenu(result);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Settings>>[
        const PopupMenuItem<Settings>(
          value: Settings.changePlan,
          child: Text('Change Plan'),
        ),
        const PopupMenuItem<Settings>(
          value: Settings.addProfilePicture,
          child: Text('Add profile picture'),
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

  _settingsMenu(Settings result) {
    switch (result) {
      case Settings.changePlan:
        return _alertDialog(context);
        break;
      case Settings.addProfilePicture:
        return _showPicker(context);
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

  Future _alertDialog(BuildContext context) {
    List<String> plans = [i18n.loseWeight, i18n.keepWeight, i18n.gainWeight];
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
      },
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () async {
                        await _imgFromGallery();
                        Navigator.of(context).pop();
                        setState(() {});
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () async {
                      await _imgFromCamera();
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromCamera() async {
    PickedFile image = await _imagePicker.getImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() async {
      _personalData.setImagePath(image.path);
    });

    _homeBloc.add(SaveImage(_personalData.imagePath));
  }

  _imgFromGallery() async {
    PickedFile image = await _imagePicker.getImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _personalData.setImagePath(image.path);
    });

    _homeBloc.add(SaveImage(_personalData.imagePath));
  }

  Widget _summaryPersonalData() {
    return Card(
      elevation: 2,
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _summaryHeadLine("Summary"),
            _personalDataCard(),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _summaryNutritionCard() {
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
              _summaryHeadLine("Average caloric intake"),
              SizedBox(height: 15),
              _pieCaloriesChart(),
              _personalBodyStatistics(),
              SizedBox(height: 20),
            ],
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }

  Widget _pieCaloriesChart() {
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

  Widget _summaryHeadLine(String name) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, top: 10.0),
      child: Text(name, style: subTitleAddScreenStyle),
    );
  }

  Widget _personalDataCard() {
    double bmi = double.parse(_personalData.weight) /
        pow(double.parse(_personalData.height) / 100, 2);
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 26, right: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _summaryRow("Weight", "${_personalData.weight} kg"),
          _summaryRow("Height", "${_personalData.height} cm"),
          _summaryRow("Sex", "${_personalData.sex}"),
          _summaryRow("Birth date", "${_personalData.date}"),
          _summaryRow("Activity level", "${_personalData.activity}"),
          _summaryRow("Goal", "${_personalData.goal}"),
          _summaryRow("BMI", "${bmi.toStringAsFixed(2).toString()}"),
          _checkBMI(bmi),
        ],
      ),
    );
  }

  Widget _checkBMI(double bmi) {
    if (bmi >= 25) {
      return Text(i18n.highBMI, softWrap: true, style: orangeProfileTextStyle);
    } else if (bmi < 25 && bmi > 18.5) {
      return Text(i18n.normalBMI, softWrap: true, style: greenProfileTextStyle);
    } else {
      return Text(i18n.lowBMI, softWrap: true, style: orangeProfileTextStyle);
    }
  }

  Widget _personalBodyStatistics() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 26, right: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _summaryCaloriesRow("Kcal", _nutrimentsData.calories),
          _summaryCaloriesRow("Protein", _nutrimentsData.protein),
          _summaryCaloriesRow("Carbs", _nutrimentsData.carbs, padding: 0),
          _summaryCaloriesRow("Fiber", _nutrimentsData.fiber,
              style: TextStyle(), padding: 0),
          _summaryCaloriesRow("Sugars", _nutrimentsData.sugars,
              style: TextStyle()),
          _summaryCaloriesRow("Fats", _nutrimentsData.fats, padding: 0),
          _summaryCaloriesRow("Saturated fats", _nutrimentsData.saturatedFats,
              style: TextStyle()),
          _summaryCaloriesRow("Cholesterol", _nutrimentsData.cholesterol),
          _summaryCaloriesRow("Sodium", _nutrimentsData.sodium),
          _summaryCaloriesRow("Potassium", _nutrimentsData.potassium),
        ],
      ),
    );
  }

  Widget _summaryRow(
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

  Widget _summaryCaloriesRow(
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

enum Settings { changeProfileData, addProfilePicture, changePlan, logout }
