import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifestylediet/bloc/homeBloc/bloc.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/themeAccent/theme.dart';

class DetailsEditHomeScreen extends StatefulWidget {
  final DatabaseProduct product;
  final String meal;
  final String uid;
  final HomeBloc homeBloc;

  DetailsEditHomeScreen({this.product, this.meal, this.uid, this.homeBloc});

  @override
  _DetailsEditHomeScreenState createState() => _DetailsEditHomeScreenState();
}

class _DetailsEditHomeScreenState extends State<DetailsEditHomeScreen> {
  var _controller;
  final _focusNode = FocusNode();
  String _dropdownValue = 'serving';
  double _amount = 1;

  initState() {
    super.initState();
    _dropdownValue = widget.product.value;
    _amount = widget.product.amount;
    _controller =
        TextEditingController(text: widget.product.amount.toString());
    _controller.addListener(() {
      final newText = _controller.text.toLowerCase();
      _controller.value = _controller.value.copyWith(
        text: newText,
        selection: TextSelection(
            baseOffset: newText.length, extentOffset: newText.length),
        composing: TextRange.empty,
      );
    });
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.selection =
            TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Nutriments _nutriments = widget.product.nutriments;

    return Scaffold(
      appBar: appBar(context),
      body: Container(
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            titleBox(),
            caloriesCard(_nutriments),
            nutritionCard(_nutriments),
          ],
        ),
      ),
    );
  }

  Widget caloriesCard(Nutriments _nutriments) {
    return Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.topCenter,
              child: Image.network(widget.product.image),
            ),
          ),
          SizedBox(width: 30),
          Expanded(flex: 1, child: kcalButtons(_nutriments)),
        ],
      ),
    );
  }

  Widget nutritionCard(Nutriments _nutriments) {
    return Card(
      child: Container(
        alignment: Alignment.centerLeft,
        child: nutriments(_nutriments),
      ),
    );
  }

  Widget kcalButtons(Nutriments _nutriments) {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          Row(
            children: [
              servingTextField(),
              SizedBox(width: 20),
              dropDownButton(),
            ],
          ),
          calories('Calories per serving', _nutriments.caloriesPerServing),
          calories('Calories per 100g', _nutriments.caloriesPer100g),
        ],
      ),
    );
  }

  Widget calories(String text, double energy) {
    return Column(
      children: [
        SizedBox(height: 30),
        Text(text),
        Text(
          energy.toString() != 'null' ? energy.toString() : '0',
          style: subTitleAddScreenStyle(),
        ),
      ],
    );
  }

  Widget servingTextField() {
    return Container(
      width: 50,
      height: 60,
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        onChanged: (value) => setState(() {
          value = value.replaceAll(',', '.');
          _amount = double.parse(value);
        }),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black45),
          ),
        ),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(new RegExp('[0-9\,\.]')),
        ],
      ),
    );
  }

  Widget dropDownButton() {
    return Container(
      height: 60,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1.0,
            style: BorderStyle.solid,
            color: Colors.black45,
          ),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
      ),
      child: DropdownButton(
        underline: DropdownButtonHideUnderline(child: SizedBox(height: 0)),
        value: _dropdownValue,
        onChanged: (newValue) {
          setState(() {
            _dropdownValue = newValue;
          });
        },
        items: <String>['serving', '100g'].map<DropdownMenuItem<String>>(
          (String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          },
        ).toList(),
      ),
    );
  }

  Widget nutriments(Nutriments _nutriments) {
    return Row(
      children: [
        SizedBox(width: 20),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              "Nutrition info",
              style: titleAddScreenStyle(),
            ),
            SizedBox(height: 10),
            kcalInfo(_nutriments),
            SizedBox(height: 10),
            proteinInfo(_nutriments),
            SizedBox(height: 10),
            carbsInfo(_nutriments),
            SizedBox(height: 10),
            fatsInfo(_nutriments),
            SizedBox(height: 10),
          ],
        ),
      ],
    );
  }

  Widget kcalInfo(Nutriments _nutriments) {
    return hideNull(
      "kcal ",
      nutrimentsAmount(
        _nutriments.caloriesPer100g,
        _nutriments.caloriesPerServing,
      ),
      subTitleAddScreenStyle(),
    );
  }

  Widget carbsInfo(Nutriments _nutriments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        hideNull(
          "carbs ",
          nutrimentsAmount(
            _nutriments.carbs,
            _nutriments.carbsPerServing,
          ),
          subTitleAddScreenStyle(),
        ),
        hideNull(
          "fiber ",
          nutrimentsAmount(
            _nutriments.fiber,
            _nutriments.fiberPerServing,
          ),
          null,
        ),
        hideNull(
          "sugars ",
          nutrimentsAmount(
            _nutriments.sugars,
            _nutriments.sugarsPerServing,
          ),
          null,
        ),
      ],
    );
  }

  String nutrimentsAmount(double perGrams, double perServing) {
    if (perGrams == null || perServing == null) {
      return 'null';
    }
    if (_dropdownValue == 'serving') {
      perServing *= _amount;
      return perServing.roundToDouble().toString();
    }
    perGrams *= _amount;
    return perGrams.roundToDouble().toString();
  }

  Widget proteinInfo(Nutriments _nutriments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        hideNull(
          "protein ",
          nutrimentsAmount(
            _nutriments.protein,
            _nutriments.proteinPerServing,
          ),
          subTitleAddScreenStyle(),
        ),
      ],
    );
  }

  Widget fatsInfo(Nutriments _nutriments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        hideNull(
          "fats ",
          nutrimentsAmount(
            _nutriments.fats,
            _nutriments.fatsPerServing,
          ),
          subTitleAddScreenStyle(),
        ),
        hideNull(
          "saturated fats ",
          nutrimentsAmount(
            _nutriments.saturatedFats,
            _nutriments.saturatedFatsPerServing,
          ),
          null,
        ),
        SizedBox(height: 10),
        hideNull(
          "salt ",
          nutrimentsAmount(
            _nutriments.salt,
            _nutriments.saltPerServing,
          ),
          subTitleAddScreenStyle(),
        ),
      ],
    );
  }

  hideNull(String name, String value, TextStyle style) {
    if (value == 'null') return SizedBox(height: 0);
    return SizedBox(
      width: 300,
      child: Container(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: style),
            SizedBox(width: 10),
            Text(value, style: style ?? TextStyle()),
          ],
        ),
      ),
    );
  }

  Widget titleBox() {
    return SizedBox(
      height: 150,
      child: Container(
        width: double.infinity,
        color: Colors.orangeAccent,
        alignment: Alignment.bottomLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                SizedBox(width: 10),
                Flexible(
                  child: Text(
                    widget.product.name,
                    style: titleAddScreenStyle(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10)
          ],
        ),
      ),
    );
  }

  Widget appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.orangeAccent,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        FlatButton(
          onPressed: () {
            widget.homeBloc.add(
              UpdateProduct(
                  id: widget.product.id, amount: _amount, value: _dropdownValue),
            );
            widget.product.amount = _amount;
            widget.product.value = _dropdownValue;
            setState(() {});
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: Text(
            "Zapisz",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
