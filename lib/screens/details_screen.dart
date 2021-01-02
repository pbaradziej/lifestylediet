import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifestylediet/bloc/addBloc/bloc.dart';
import 'package:lifestylediet/bloc/homeBloc/bloc.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/utils/common_utils.dart';

class DetailsScreen extends StatefulWidget {
  final DatabaseProduct product;
  final String meal;
  final String uid;
  final HomeBloc homeBloc;
  final AddBloc addBloc;
  bool isEditable;
  bool isNewProduct;

  DetailsScreen(
      {this.product,
      this.meal,
      this.uid,
      this.homeBloc,
      this.addBloc,
      this.isEditable,
      this.isNewProduct});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  TextEditingController _controller;
  bool isEditable;
  bool isNewProduct;
  final _focusNode = FocusNode();
  String _dropdownValue;
  double _amount;

  initState() {
    super.initState();
    isEditable = widget.isEditable ?? false;
    isNewProduct = widget.isNewProduct ?? false;
    _dropdownValue = widget.product.value ?? 'serving';
    _amount = widget.product.amount ?? 1;
    _controller =
        TextEditingController(text: widget.product.amount.toString() ?? "1");
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
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowGlow();
        },
        child: ListView(
          physics: ClampingScrollPhysics(),
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
          Expanded(flex: 1, child: kcalButtons(_nutriments)),
        ],
      ),
    );
  }

  Widget nutritionCard(Nutriments _nutriments) {
    return Card(
      child: nutriments(_nutriments),
    );
  }

  Widget kcalButtons(Nutriments _nutriments) {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          SizedBox(height: 20),
          Row(
            children: [
              _servingTextField(),
              SizedBox(width: 15),
              _valueDropdownButton(),
            ],
          ),
          calories('Calories per serving', _nutriments.caloriesPerServing),
          calories('Calories per 100g', _nutriments.caloriesPer100g),
        ],
      ),
    );
  }

  Widget calories(String text, double energy) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: '$text\n',
            style: defaultTextStyle,
          ),
          TextSpan(
            text: energy.toString() != 'null' ? energy.toString() : '0',
            style: subTitleAddScreenStyle,
          ),
        ],
      ),
    );
  }

  Widget _servingTextField() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            'Amount',
            textAlign: TextAlign.center,
            style: defaultTextStyle,
          ),
        ),
        Container(
          width: 50,
          padding: const EdgeInsets.only(top: 2),
          height: 60,
          child: TextFormField(
            enabled: isEditable,
            controller: _controller,
            style: defaultTextStyle,
            focusNode: _focusNode,
            onChanged: (value) => setState(() {
              value = value.replaceAll(',', '.');
              _amount = double.parse(value);
            }),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: isEditable
                    ? BorderSide(color: Colors.black45)
                    : BorderSide.none,
              ),
            ),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(new RegExp('[0-9\,\.]')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _valueDropdownButton() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            'Value',
            style: defaultTextStyle,
          ),
        ),
        isEditable
            ? _dropdownButton()
            : Container(
                alignment: Alignment.center,
                height: 60,
                width: 80,
                child: Text(_dropdownValue, style: defaultTextStyle)),
      ],
    );
  }

  Widget _dropdownButton() {
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
        style: defaultTextStyle,
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 10, bottom: 10),
          child: Text(
            "Nutrition info",
            style: titleAddScreenStyle,
          ),
        ),
        _nutritionInfo(_nutriments),
      ],
    );
  }

  Widget _nutritionInfo(Nutriments _nutriments) {
    return Column(
      children: [
        kcalInfo(_nutriments),
        SizedBox(height: 10),
        proteinInfo(_nutriments),
        SizedBox(height: 10),
        carbsInfo(_nutriments),
        SizedBox(height: 10),
        fatsInfo(_nutriments),
        SizedBox(height: 10),
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
        ),
        hideNull(
          "fiber ",
          nutrimentsAmount(
            _nutriments.fiber,
            _nutriments.fiberPerServing,
          ),
          style: TextStyle(),
        ),
        hideNull(
          "sugars ",
          nutrimentsAmount(
            _nutriments.sugars,
            _nutriments.sugarsPerServing,
          ),
          style: TextStyle(),
        ),
      ],
    );
  }

  String nutrimentsAmount(double perGrams, double perServing) {
    if (perGrams == -1 ||
        perServing == -1 ||
        perGrams == null ||
        perServing == null) {
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
        ),
        hideNull(
          "saturated fats ",
          nutrimentsAmount(
            _nutriments.saturatedFats,
            _nutriments.saturatedFatsPerServing,
          ),
          style: TextStyle(),
        ),
        SizedBox(height: 10),
        hideNull(
          "salt ",
          nutrimentsAmount(
            _nutriments.salt,
            _nutriments.saltPerServing,
          ),
        ),
      ],
    );
  }

  hideNull(String name, String value, {TextStyle style}) {
    if (value == 'null') return SizedBox(height: 0);
    TextStyle defaultStyle = style ?? subTitleAddScreenStyle;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          child: Text(name, style: defaultStyle),
          padding: const EdgeInsets.only(left: 20),
        ),
        new Spacer(
          flex: 1,
        ),
        Padding(
          child: Text(value, style: defaultStyle),
          padding: const EdgeInsets.only(right: 20),
        ),
      ],
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
                    style: titleAddScreenStyle,
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
          onPressed: () {
            setState(() {
              isNewAction();
            });
          }),
      actions: [actionButtons()],
    );
  }

  isNewAction() {
    if (isEditable && !isNewProduct) {
      isEditable = false;
      return;
    }

    return Navigator.pop(context);
  }

  Widget actionButtons() {
    if (isEditable && isNewProduct) {
      return newButtons();
    } else if (isEditable) {
      return editButtons();
    }

    return previewButtons();
  }

  Widget newButtons() {
    return FlatButton(
      onPressed: () {
        Navigator.pop(context);
        widget.addBloc.add(
          AddProduct(
              uid: widget.uid,
              meal: widget.meal,
              product: widget.product,
              amount: _amount,
              value: _dropdownValue),
        );
        widget.addBloc.add(AddReturn());
      },
      child: Text(
        "Zapisz",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget previewButtons() {
    return Row(
      children: [
        FlatButton(
          onPressed: () {
            widget.homeBloc.add(
              DeleteProduct(id: widget.product.id),
            );
            setState(() {});
            Navigator.pop(context);
          },
          child: Text(
            "Usuń",
            style: TextStyle(color: Colors.white),
          ),
        ),
        FlatButton(
          onPressed: () {
            setState(() {
              isEditable = true;
            });
          },
          child: Text(
            "Edytuj",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget editButtons() {
    return FlatButton(
      onPressed: () {
        widget.homeBloc.add(
          UpdateProduct(
              id: widget.product.id, amount: _amount, value: _dropdownValue),
        );
        Navigator.pop(context);
      },
      child: Text(
        "Zapisz",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
