import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifestylediet/bloc/addBloc/bloc.dart';
import 'package:lifestylediet/themeAccent/theme.dart';
import 'package:openfoodfacts/model/Nutriments.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class DetailsScreen extends StatefulWidget {
  final Product product;
  final String meal;
  final String uid;
  final AddBloc addBloc;

  DetailsScreen({this.product, this.meal, this.uid, this.addBloc});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final _controller = TextEditingController(text: '1');
  final _focusNode = FocusNode();
  String _dropdownValue = 'serving';
  double amount = 1;

  initState() {
    super.initState();
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 30),
          Expanded(
              flex: 40,
              child: Image.network(widget.product.selectedImages[1].url)),
          SizedBox(width: 10),
          Expanded(flex: 60, child: kcalButtons(_nutriments)),
          SizedBox(width: 30),
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
          calories('Calories per serving', _nutriments.energyServing),
          calories('Calories per 100g', _nutriments.energyKcal100g),
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
          amount = double.parse(value);
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
            carbsInfo(_nutriments),
            SizedBox(height: 10),
            proteinInfo(_nutriments),
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
        _nutriments.energyKcal100g,
        _nutriments.energyServing,
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
            _nutriments.carbohydrates,
            _nutriments.carbohydratesServing,
          ),
          subTitleAddScreenStyle(),
        ),
        hideNull(
          "fiber ",
          nutrimentsAmount(
            _nutriments.fiber,
            _nutriments.fiberServing,
          ),
          null,
        ),
        hideNull(
          "sugars ",
          nutrimentsAmount(
            _nutriments.sugars,
            _nutriments.sugarsServing,
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
      perServing *= amount;
      return perServing.roundToDouble().toString();
    }
    perGrams *= amount;
    return perGrams.roundToDouble().toString();
  }

  Widget proteinInfo(Nutriments _nutriments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        hideNull(
          "protein ",
          nutrimentsAmount(
            _nutriments.proteins,
            _nutriments.proteinsServing,
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
            _nutriments.fat,
            _nutriments.fatServing,
          ),
          subTitleAddScreenStyle(),
        ),
        hideNull(
          "saturated fats ",
          nutrimentsAmount(
            _nutriments.saturatedFat,
            _nutriments.saturatedFatServing,
          ),
          null,
        ),
        SizedBox(height: 10),
        hideNull(
          "salt ",
          nutrimentsAmount(
            _nutriments.salt,
            _nutriments.saltServing,
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
                    widget.product.productName ?? 'no info',
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
            Navigator.pop(context);
            widget.addBloc.add(
              AddProduct(
                  uid: widget.uid,
                  meal: widget.meal,
                  product: widget.product,
                  amount: amount,
                  value: _dropdownValue),
            );
            widget.addBloc.add(AddReturn());
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
