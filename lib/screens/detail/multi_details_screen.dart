import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/cubits/product/product_cubit.dart';
import 'package:lifestylediet/cubits/routing/routing_cubit.dart';
import 'package:lifestylediet/models/database_product.dart';
import 'package:lifestylediet/models/nutriments.dart';
import 'package:lifestylediet/models/product_panel.dart';
import 'package:lifestylediet/utils/fonts.dart';
import 'package:lifestylediet/utils/palette.dart';

class MultiDetailsScreen extends StatefulWidget {
  final List<DatabaseProduct> products;

  const MultiDetailsScreen({
    required this.products,
  });

  @override
  _MultiDetailsScreenState createState() => _MultiDetailsScreenState();
}

class _MultiDetailsScreenState extends State<MultiDetailsScreen> {
  late ProductCubit productCubit;
  late RoutingCubit routingCubit;
  late List<ProductPanel> productPanels;

  @override
  void initState() {
    super.initState();
    productCubit = context.read();
    routingCubit = context.read();
    productPanels = ProductPanel.createProductPanels(widget.products);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowIndicator();
          return false;
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

  AppBar appBar(BuildContext context) {
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
        },
      ),
      actions: <Widget>[
        newButtons(),
      ],
    );
  }

  Widget newButtons() {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        'Save',
        style: labelStyle,
      ),
    );
  }

  void onPressed() async {
    final List<DatabaseProduct> products = getDatabaseProducts();
    await productCubit.addMultipleProducts(products);
    routingCubit.showHomeScreen();
    Navigator.pop(context);
  }

  List<DatabaseProduct> getDatabaseProducts() {
    return <DatabaseProduct>[
      for (ProductPanel panel in productPanels) panel.databaseProduct,
    ];
  }

  ExpansionPanelList productPanelList() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          productPanels[index] = productPanels[index].copyWith(isExpanded: !isExpanded);
        });
      },
      children: productPanels.map((ProductPanel panel) {
        final DatabaseProduct databaseProduct = panel.databaseProduct;
        final Nutriments nutriments = databaseProduct.nutriments;
        return ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(
                databaseProduct.name.toUpperCase(),
                softWrap: true,
              ),
            );
          },
          isExpanded: panel.isExpanded,
          body: Column(
            children: <Widget>[
              caloriesCard(databaseProduct),
              nutritionCard(nutriments, databaseProduct),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget caloriesCard(DatabaseProduct product) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.topCenter,
                child: Image.network(product.image),
              ),
            ),
            Expanded(
              child: kcalButtons(product),
            ),
          ],
        ),
      ),
    );
  }

  Widget kcalButtons(DatabaseProduct product) {
    final Nutriments nutriments = product.nutriments;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      alignment: Alignment.topCenter,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          Row(
            children: <Widget>[
              servingTextField(product),
              const SizedBox(width: 15),
              valueDropdownButton(product),
            ],
          ),
          calories('Calories per serving', nutriments.caloriesPerServing),
          calories('Calories per 100${product.servingUnit}', nutriments.caloriesPer100g),
        ],
      ),
    );
  }

  Widget servingTextField(DatabaseProduct product) {
    return Column(
      children: <Widget>[
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
            initialValue: '1',
            style: defaultTextStyle,
            onChanged: (String value) => setState(() {
              value = value.replaceAll(',', '.');
              product = product.copyWith(
                amount: double.parse(value),
              );
            }),
            decoration: InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide(color: defaultBorderColor)),
            ),
            textAlign: TextAlign.center,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp('[0-9\,\.]')),
            ],
          ),
        ),
      ],
    );
  }

  Widget valueDropdownButton(DatabaseProduct product) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            'Value',
            style: defaultTextStyle,
          ),
        ),
        dropdownButton(product)
      ],
    );
  }

  Widget dropdownButton(DatabaseProduct product) {
    return Container(
      height: 60,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: defaultBorderColor,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        ),
      ),
      child: DropdownButton<String>(
        style: defaultTextStyle,
        underline: const DropdownButtonHideUnderline(child: SizedBox(height: 0)),
        value: product.value,
        onChanged: (String? newValue) {
          setState(() {
            product = product.copyWith(
              value: newValue ?? '',
            );
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

  Widget nutritionCard(Nutriments nutriments, DatabaseProduct product) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 10, bottom: 10),
            child: Text(
              'Nutrition info',
              style: titleAddScreenStyle,
            ),
          ),
          nutritionInfo(nutriments, product),
        ],
      ),
    );
  }

  Widget nutritionInfo(Nutriments nutriments, DatabaseProduct product) {
    return Column(
      children: <Widget>[
        kcalInfo(nutriments, product),
        const SizedBox(height: 10),
        proteinInfo(nutriments, product),
        const SizedBox(height: 10),
        carbsInfo(nutriments, product),
        const SizedBox(height: 10),
        fatsInfo(nutriments, product),
        const SizedBox(height: 10),
        additionalInfo(nutriments, product),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget kcalInfo(Nutriments nutriments, DatabaseProduct product) {
    return hideNull(
      'kcal ',
      nutrimentsAmount(
        nutriments.caloriesPer100g,
        nutriments.caloriesPerServing,
        product,
      ),
    );
  }

  Widget proteinInfo(Nutriments nutriments, DatabaseProduct product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        hideNull(
          'protein ',
          nutrimentsAmount(
            nutriments.protein,
            nutriments.proteinPerServing,
            product,
          ),
        ),
      ],
    );
  }

  Widget carbsInfo(Nutriments nutriments, DatabaseProduct product) {
    return Column(
      children: <Widget>[
        hideNull(
          'carbs ',
          nutrimentsAmount(
            nutriments.carbs,
            nutriments.carbsPerServing,
            product,
          ),
        ),
        hideNull(
          'fiber ',
          nutrimentsAmount(
            nutriments.fiber,
            nutriments.fiberPerServing,
            product,
          ),
          style: const TextStyle(),
        ),
        hideNull(
          'sugars ',
          nutrimentsAmount(
            nutriments.sugars,
            nutriments.sugarsPerServing,
            product,
          ),
          style: const TextStyle(),
        ),
      ],
    );
  }

  Widget fatsInfo(Nutriments nutriments, DatabaseProduct product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        hideNull(
          'fats ',
          nutrimentsAmount(
            nutriments.fats,
            nutriments.fatsPerServing,
            product,
          ),
        ),
        hideNull(
          'saturated fats ',
          nutrimentsAmount(
            nutriments.saturatedFats,
            nutriments.saturatedFatsPerServing,
            product,
          ),
          style: const TextStyle(),
        ),
      ],
    );
  }

  Widget additionalInfo(Nutriments nutriments, DatabaseProduct product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        hideNull(
          'Cholesterol ',
          nutrimentsAmount(
            nutriments.cholesterol,
            nutriments.cholesterolPerServing,
            product,
          ),
        ),
        hideNull(
          'Sodium ',
          nutrimentsAmount(
            nutriments.sodium,
            nutriments.sodiumPerServing,
            product,
          ),
        ),
        hideNull(
          'Potassium ',
          nutrimentsAmount(
            nutriments.potassium,
            nutriments.potassiumPerServing,
            product,
          ),
        ),
      ],
    );
  }

  String nutrimentsAmount(double perGrams, double perServing, DatabaseProduct product) {
    if (perGrams == -1 || perServing == -1) {
      return 'null';
    }
    if (product.value == 'serving') {
      perServing *= product.amount;
      return double.parse(perServing.toStringAsFixed(2)).toString();
    }
    perGrams *= product.amount;
    return double.parse(perGrams.toStringAsFixed(2)).toString();
  }

  Widget hideNull(String name, String value, {TextStyle? style}) {
    if (value == 'null') return const SizedBox(height: 0);
    final TextStyle defaultStyle = style ?? subTitleAddScreenStyle;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            name,
            style: defaultStyle,
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Text(
            value,
            style: defaultStyle,
          ),
        ),
      ],
    );
  }
}
