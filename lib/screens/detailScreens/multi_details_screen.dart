import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifestylediet/bloc/addBloc/bloc.dart';
import 'package:lifestylediet/bloc/homeBloc/bloc.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/utils/common_utils.dart';

class MultiDetailsScreen extends StatefulWidget {
  final List<DatabaseProduct> products;
  final String meal;
  final String uid;
  final HomeBloc homeBloc;
  final AddBloc addBloc;
  final String currentDate;

  MultiDetailsScreen({
    this.products,
    this.meal,
    this.uid,
    this.homeBloc,
    this.addBloc,
    this.currentDate,
  });

  @override
  _MultiDetailsScreenState createState() => _MultiDetailsScreenState();
}

class _MultiDetailsScreenState extends State<MultiDetailsScreen> {
  List<DatabaseProduct> _products;

  initState() {
    super.initState();
    _products = widget.products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowGlow();
        },
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(bottom: 15),
            child: productPanelList(),
          ),
        ),
      ),
    );
  }

  ExpansionPanelList productPanelList() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _products[index].isExpanded = !isExpanded;
        });
      },
      children: _products.map((DatabaseProduct product) {
        Nutriments nutriments = product.nutriments;
        return ExpansionPanel(
            canTapOnHeader: true,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  product.name.toUpperCase() ?? "no info",
                  softWrap: true,
                ),
              );
            },
            isExpanded: product.isExpanded,
            body: Column(
              children: [
                _caloriesCard(product),
                _nutritionCard(nutriments, product),
              ],
            ));
      }).toList(),
    );
  }

  Widget _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: backgroundColor,
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: defaultColor,
          ),
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          }),
      actions: [newButtons()],
    );
  }

  Widget newButtons() {
    return FlatButton(
      onPressed: () {
        Navigator.pop(context);
        widget.addBloc.add(
          AddProductList(products: widget.products),
        );
        widget.addBloc.add(AddReturn());
      },
      child: Text(
        "Save",
        style: labelStyle,
      ),
    );
  }

  Widget _caloriesCard(DatabaseProduct product) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.topCenter,
                child: Image.network(product.image),
              ),
            ),
            Expanded(flex: 1, child: _kcalButtons(product)),
          ],
        ),
      ),
    );
  }

  Widget _nutritionCard(Nutriments nutriments, DatabaseProduct product) {
    return Card(
      child: Column(
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
          _nutritionInfo(nutriments, product),
        ],
      ),
    );
  }

  Widget _kcalButtons(DatabaseProduct product) {
    Nutriments nutriments = product.nutriments;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          SizedBox(height: 20),
          Row(
            children: [
              _servingTextField(product),
              SizedBox(width: 15),
              _valueDropdownButton(product),
            ],
          ),
          _calories('Calories per serving', nutriments.caloriesPerServing),
          _calories('Calories per 100${product.servingUnit}',
              nutriments.caloriesPer100g),
        ],
      ),
    );
  }

  Widget _calories(String text, double energy) {
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

  Widget _servingTextField(DatabaseProduct product) {
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
            initialValue: "1",
            style: defaultTextStyle,
            onChanged: (value) => setState(() {
              value = value.replaceAll(',', '.');
              product.amount = double.parse(value);
            }),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: defaultBorderColor)),
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

  Widget _valueDropdownButton(DatabaseProduct product) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            'Value',
            style: defaultTextStyle,
          ),
        ),
        _dropdownButton(product)
      ],
    );
  }

  Widget _dropdownButton(DatabaseProduct product) {
    return Container(
      height: 60,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1.0,
            style: BorderStyle.solid,
            color: defaultBorderColor,
          ),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
      ),
      child: DropdownButton(
        style: defaultTextStyle,
        underline: DropdownButtonHideUnderline(child: SizedBox(height: 0)),
        value: product.value ?? 1,
        onChanged: (newValue) {
          setState(() {
            product.value = newValue;
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

  Widget _nutritionInfo(Nutriments nutriments, DatabaseProduct product) {
    return Column(
      children: [
        _kcalInfo(nutriments, product),
        SizedBox(height: 10),
        _proteinInfo(nutriments, product),
        SizedBox(height: 10),
        _carbsInfo(nutriments, product),
        SizedBox(height: 10),
        _fatsInfo(nutriments, product),
        SizedBox(height: 10),
        _additionalInfo(nutriments, product),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _kcalInfo(Nutriments nutriments, DatabaseProduct product) {
    return _hideNull(
      "kcal ",
      _nutrimentsAmount(
        nutriments.caloriesPer100g,
        nutriments.caloriesPerServing,
        product,
      ),
    );
  }

  Widget _proteinInfo(Nutriments nutriments, DatabaseProduct product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _hideNull(
          "protein ",
          _nutrimentsAmount(
            nutriments.protein,
            nutriments.proteinPerServing,
            product,
          ),
        ),
      ],
    );
  }

  Widget _carbsInfo(Nutriments nutriments, DatabaseProduct product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _hideNull(
          "carbs ",
          _nutrimentsAmount(
            nutriments.carbs,
            nutriments.carbsPerServing,
            product,
          ),
        ),
        _hideNull(
          "fiber ",
          _nutrimentsAmount(
            nutriments.fiber,
            nutriments.fiberPerServing,
            product,
          ),
          style: TextStyle(),
        ),
        _hideNull(
          "sugars ",
          _nutrimentsAmount(
            nutriments.sugars,
            nutriments.sugarsPerServing,
            product,
          ),
          style: TextStyle(),
        ),
      ],
    );
  }

  Widget _fatsInfo(Nutriments nutriments, DatabaseProduct product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _hideNull(
          "fats ",
          _nutrimentsAmount(
            nutriments.fats,
            nutriments.fatsPerServing,
            product,
          ),
        ),
        _hideNull(
          "saturated fats ",
          _nutrimentsAmount(
            nutriments.saturatedFats,
            nutriments.saturatedFatsPerServing,
            product,
          ),
          style: TextStyle(),
        ),
      ],
    );
  }

  Widget _additionalInfo(Nutriments nutriments, DatabaseProduct product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _hideNull(
          "Cholesterol ",
          _nutrimentsAmount(
            nutriments.cholesterol,
            nutriments.cholesterolPerServing,
            product,
          ),
        ),
        _hideNull(
          "Sodium ",
          _nutrimentsAmount(
            nutriments.sodium,
            nutriments.sodiumPerServing,
            product,
          ),
        ),
        _hideNull(
          "Potassium ",
          _nutrimentsAmount(
            nutriments.potassium,
            nutriments.potassiumPerServing,
            product,
          ),
        ),
      ],
    );
  }

  String _nutrimentsAmount(
      double perGrams, double perServing, DatabaseProduct product) {
    if (perGrams == -1 ||
        perServing == -1 ||
        perGrams == null ||
        perServing == null) {
      return 'null';
    }
    if (product.value == 'serving') {
      perServing *= product.amount;
      return double.parse((perServing).toStringAsFixed(2)).toString();
    }
    perGrams *= product.amount;
    return double.parse((perGrams).toStringAsFixed(2)).toString();
  }

  _hideNull(String name, String value, {TextStyle style}) {
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
}
