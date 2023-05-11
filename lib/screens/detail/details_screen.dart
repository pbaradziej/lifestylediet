import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/cubits/product/product_cubit.dart';
import 'package:lifestylediet/cubits/routing/routing_cubit.dart';
import 'package:lifestylediet/models/database_product.dart';
import 'package:lifestylediet/models/nutriments.dart';
import 'package:lifestylediet/utils/fonts.dart';
import 'package:lifestylediet/utils/palette.dart';

class DetailsScreen extends StatefulWidget {
  final DatabaseProduct product;
  final bool isEditable;
  final bool isNewProduct;

  const DetailsScreen({
    required this.product,
    this.isEditable = false,
    this.isNewProduct = false,
  });

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late ProductCubit productCubit;
  late RoutingCubit routingCubit;
  late double amount;
  late TextEditingController controller;
  late bool isEditable;
  late bool isNewProduct;
  late FocusNode focusNode;
  late String dropdownValue;
  late Nutriments nutriments;

  DatabaseProduct get product => widget.product;

  @override
  void initState() {
    super.initState();
    productCubit = context.read();
    routingCubit = context.read();
    amount = product.amount;
    final String parsedAmount = amount.toString();
    controller = TextEditingController(text: parsedAmount);
    isEditable = widget.isEditable;
    isNewProduct = widget.isNewProduct;
    focusNode = FocusNode();
    dropdownValue = product.value;
    nutriments = product.nutriments;
    initServingTextListener();
    initFocusListener();
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
        child: ListView(
          physics: const ClampingScrollPhysics(),
          children: <Widget>[
            titleBox(),
            caloriesCard(),
            nutritionCard(),
          ],
        ),
      ),
    );
  }

  void initServingTextListener() {
    controller.addListener(() {
      final String newText = controller.text.toLowerCase();
      controller.value = controller.value.copyWith(
        text: newText,
        selection: TextSelection(baseOffset: newText.length, extentOffset: newText.length),
        composing: TextRange.empty,
      );
    });
  }

  void initFocusListener() {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.text.length);
      }
    });
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
          setState(isNewAction);
        },
      ),
      actions: <Widget>[
        actionButtons(),
      ],
    );
  }

  void isNewAction() {
    if (isEditable && !isNewProduct) {
      isEditable = false;
      return;
    }

    Navigator.pop(context);
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
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        'Save',
        style: labelStyle,
      ),
    );
  }

  void onPressed() async {
    final DatabaseProduct updatedProduct = getUpdatedProduct();
    await productCubit.addProduct(updatedProduct);
    routingCubit.showHomeScreen();
    Navigator.pop(context);
  }

  Widget editButtons() {
    return ElevatedButton(
      onPressed: () {
        final DatabaseProduct updatedProduct = getUpdatedProduct();
        productCubit.updateProduct(updatedProduct);
        Navigator.pop(context);
      },
      child: Text(
        'Save',
        style: labelStyle,
      ),
    );
  }

  DatabaseProduct getUpdatedProduct() {
    return product.copyWith(
      amount: amount,
      value: dropdownValue,
    );
  }

  Widget previewButtons() {
    return Row(
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            productCubit.deleteProduct(product);
            Navigator.pop(context);
          },
          child: Text(
            'Delete',
            style: labelStyle,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              isEditable = true;
            });
          },
          child: Text(
            'Edit',
            style: labelStyle,
          ),
        ),
      ],
    );
  }

  Widget titleBox() {
    return SizedBox(
      height: 150,
      child: Container(
        width: double.infinity,
        color: backgroundColor,
        alignment: Alignment.bottomLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Row(
              children: <Widget>[
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    product.name,
                    style: titleAddScreenStyle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10)
          ],
        ),
      ),
    );
  }

  Widget caloriesCard() {
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
              child: kcalButtons(),
            ),
          ],
        ),
      ),
    );
  }

  Widget kcalButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      alignment: Alignment.topCenter,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          caloriesFields(),
          calories('Calories per serving', nutriments.caloriesPerServing),
          calories('Calories per 100${product.servingUnit}', nutriments.caloriesPer100g),
        ],
      ),
    );
  }

  Widget caloriesFields() {
    return Row(
      children: <Widget>[
        servingTextField(),
        const SizedBox(width: 15),
        valueDropdownButton(),
      ],
    );
  }

  Widget servingTextField() {
    //TODO przerobić na TextFormFieldComponent
    return Column(
      children: <Widget>[
        servingLabel(),
        servingTextComponent(),
      ],
    );
  }

  Widget servingLabel() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        'Amount',
        textAlign: TextAlign.center,
        style: defaultTextStyle,
      ),
    );
  }

  Widget servingTextComponent() {
    return Container(
      width: 50,
      padding: const EdgeInsets.only(top: 2),
      height: 60,
      child: TextFormField(
        enabled: isEditable,
        controller: controller,
        style: defaultTextStyle,
        focusNode: focusNode,
        onChanged: onChanged,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: isEditable ? BorderSide(color: defaultBorderColor) : BorderSide.none,
          ),
        ),
        textAlign: TextAlign.center,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp('[0-9\,\.]')),
        ],
      ),
    );
  }

  void onChanged(String value) {
    setState(() {
      value = value.isNotEmpty ? value : '0';
      value = value.replaceAll(',', '.');
      amount = double.parse(value);
    });
  }

  Widget valueDropdownButton() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            'Value',
            style: defaultTextStyle,
          ),
        ),
        isEditable ? dropdownButton() : previewDropdownButton(), //TODO wdrożyć readonly mode do dropdownButtona
      ],
    );
  }

  Widget dropdownButton() {
    return Container(
      //TODO użyć mojego dropdownButtona
      height: 60,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: defaultBorderColor,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
      ),
      child: DropdownButton<String>(
        style: defaultTextStyle,
        underline: const DropdownButtonHideUnderline(child: SizedBox()),
        value: dropdownValue,
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue ?? '';
          });
        },
        items: dropDownItems(),
      ),
    );
  }

  List<DropdownMenuItem<String>> dropDownItems() {
    final List<String> servings = <String>['serving', '100g'];
    return <DropdownMenuItem<String>>[
      for (final String serving in servings)
        DropdownMenuItem<String>(
          value: serving,
          child: Text(
            serving,
          ),
        )
    ];
  }

  Widget previewDropdownButton() {
    return Container(
      alignment: Alignment.center,
      height: 60,
      width: 80,
      child: Text(
        dropdownValue,
        style: defaultTextStyle,
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

  Widget nutritionCard() {
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
          nutritionInfo(),
        ],
      ),
    );
  }

  Widget nutritionInfo() {
    return Column(
      children: <Widget>[
        kcalInfo(),
        const SizedBox(height: 10),
        proteinInfo(),
        const SizedBox(height: 10),
        carbsInfo(),
        const SizedBox(height: 10),
        fatsInfo(),
        const SizedBox(height: 10),
        additionalInfo(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget kcalInfo() {
    return hideNull(
      'kcal ',
      nutrimentsAmount(
        nutriments.caloriesPer100g,
        nutriments.caloriesPerServing,
      ),
    );
  }

  Widget proteinInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        hideNull(
          'protein ',
          nutrimentsAmount(
            nutriments.protein,
            nutriments.proteinPerServing,
          ),
        ),
      ],
    );
  }

  Widget carbsInfo() {
    return Column(
      children: <Widget>[
        hideNull(
          'carbs ',
          nutrimentsAmount(
            nutriments.carbs,
            nutriments.carbsPerServing,
          ),
        ),
        hideNull(
          'fiber ',
          nutrimentsAmount(
            nutriments.fiber,
            nutriments.fiberPerServing,
          ),
          style: const TextStyle(),
        ),
        hideNull(
          'sugars ',
          nutrimentsAmount(
            nutriments.sugars,
            nutriments.sugarsPerServing,
          ),
          style: const TextStyle(),
        ),
      ],
    );
  }

  Widget fatsInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        hideNull(
          'fats ',
          nutrimentsAmount(
            nutriments.fats,
            nutriments.fatsPerServing,
          ),
        ),
        hideNull(
          'saturated fats ',
          nutrimentsAmount(
            nutriments.saturatedFats,
            nutriments.saturatedFatsPerServing,
          ),
          style: const TextStyle(),
        ),
      ],
    );
  }

  Widget additionalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        hideNull(
          'Cholesterol ',
          nutrimentsAmount(
            nutriments.cholesterol,
            nutriments.cholesterolPerServing,
          ),
        ),
        hideNull(
          'Sodium ',
          nutrimentsAmount(
            nutriments.sodium,
            nutriments.sodiumPerServing,
          ),
        ),
        hideNull(
          'Potassium ',
          nutrimentsAmount(
            nutriments.potassium,
            nutriments.potassiumPerServing,
          ),
        ),
      ],
    );
  }

  String nutrimentsAmount(double perGrams, double perServing) {
    if (perGrams == -1 || perServing == -1) {
      return 'null';
    }
    if (dropdownValue == 'serving') {
      perServing *= amount;
      return double.parse(perServing.toStringAsFixed(2)).toString();
    }
    perGrams *= amount;

    return double.parse(perGrams.toStringAsFixed(2)).toString();
  }

  Widget hideNull(String name, String value, {TextStyle? style}) {
    if (value == 'null') {
      return const SizedBox();
    }

    final TextStyle defaultStyle = style ?? subTitleAddScreenStyle;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(name, style: defaultStyle),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Text(value, style: defaultStyle),
        ),
      ],
    );
  }
}
