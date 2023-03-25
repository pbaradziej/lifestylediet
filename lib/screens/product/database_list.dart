import 'package:flutter/material.dart';
import 'package:lifestylediet/models/database_product.dart';
import 'package:lifestylediet/models/nutriments.dart';
import 'package:lifestylediet/screens/detail/details_screen_provider.dart';
import 'package:lifestylediet/styles/app_text_styles.dart';

class DatabaseListScreen extends StatefulWidget {
  final List<DatabaseProduct> products;

  const DatabaseListScreen({
    required this.products,
  });

  @override
  _DatabaseListScreenState createState() => _DatabaseListScreenState();
}

class _DatabaseListScreenState extends State<DatabaseListScreen> {
  late List<DatabaseProduct> products;

  @override
  void initState() {
    super.initState();
    products = widget.products;
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          return showFood(products, index);
        },
      ),
    );
  }

  Widget showFood(List<DatabaseProduct> products, int index) {
    final DatabaseProduct product = products[index];
    final Nutriments nutriments = product.nutriments;

    return SizedBox(
      height: 100,
      child: Card(
        child: InkWell(
          onTap: () => detailsNavigator(product),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 22,
                child: Image.network(product.image),
              ),
              const Expanded(flex: 3, child: SizedBox()),
              tileContent(product, nutriments),
              const Expanded(flex: 3, child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }

  void detailsNavigator(DatabaseProduct product) {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext _) => DetailsScreenProvider(
          product: product,
          context: context,
          isEditable: true,
          isNewProduct: true,
        ),
      ),
    );
  }

  Widget tileContent(DatabaseProduct product, Nutriments nutriments) {
    return Expanded(
      flex: 72,
      child: Row(
        children: <Widget>[
          mainContent(product, nutriments),
          subContent(product, nutriments),
        ],
      ),
    );
  }

  Widget mainContent(DatabaseProduct product, Nutriments nutriments) {
    return Expanded(
      flex: 75,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            product.name,
            softWrap: true,
          ),
          subtitleListTile(product, nutriments),
        ],
      ),
    );
  }

  Widget subtitleListTile(DatabaseProduct product, Nutriments nutriments) {
    final double proteinPerServing = nutriments.proteinPerServing;
    final double carbsPerServing = nutriments.carbsPerServing;
    final double fatsPerServing = nutriments.fatsPerServing;

    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[
          TextSpan(
            text: showValue('protein: ', proteinPerServing),
            style: AppTextStyle.bodySmall(context),
          ),
          TextSpan(
            text: showValue(' carbs: ', carbsPerServing),
            style: AppTextStyle.bodySmall(context),
          ),
          TextSpan(
            text: showValue(' fat: ', fatsPerServing),
            style: AppTextStyle.bodySmall(context),
          ),
        ],
      ),
    );
  }

  Widget subContent(DatabaseProduct product, Nutriments nutriments) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        trailingListTile(product, nutriments),
      ],
    );
  }

  Widget trailingListTile(DatabaseProduct product, Nutriments nutriments) {
    final double caloriesPerServing = nutriments.caloriesPerServing;
    final String servingUnit = product.servingUnit;
    final double caloriesPer100g = nutriments.caloriesPer100g;

    return Column(
      children: <Widget>[
        Text(
          showValue('kcal: ', caloriesPerServing),
          style: AppTextStyle.bodySmall(context),
        ),
        Text(
          showValue('kcal 100$servingUnit: ', caloriesPer100g),
          style: AppTextStyle.bodySmall(context),
        ),
      ],
    );
  }

  String showValue(String name, double value) {
    final String parsedValue = value.toString();
    if (parsedValue == 'null' || parsedValue == '-1.0') {
      return '$name?';
    }

    return name + parsedValue;
  }
}
