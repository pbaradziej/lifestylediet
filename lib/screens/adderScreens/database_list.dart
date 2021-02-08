import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/bloc/addBloc/bloc.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/screens/screens.dart';
import 'package:lifestylediet/utils/common_utils.dart';

class DatabaseListScreen extends StatefulWidget {
  final List<DatabaseProduct> products;

  const DatabaseListScreen({Key key, this.products}) : super(key: key);

  @override
  _DatabaseListScreenState createState() => _DatabaseListScreenState();
}

class _DatabaseListScreenState extends State<DatabaseListScreen> {
  List<DatabaseProduct> _products;
  AddBloc _addBloc;

  @override
  void initState() {
    _products = widget.products;
    _addBloc = BlocProvider.of<AddBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: ListView.builder(
        physics: ClampingScrollPhysics(),
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        itemCount: _products.length,
        itemBuilder: (context, index) {
          return _showFood(_products, index);
        },
      ),
    );
  }

  Widget _showFood(List<DatabaseProduct> products, int index) {
    DatabaseProduct product = products[index];
    Nutriments nutriments = product.nutriments;

    return Container(
      height: 100,
      child: Card(
        child: InkWell(
          onTap: () => _detailsNavigator(product),
          child: Row(
            children: [
              Expanded(
                flex: 22,
                child: Image.network(product.image),
              ),
              Expanded(flex: 3, child: SizedBox()),
              _tileContent(product, nutriments),
              Expanded(flex: 3, child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }

  _detailsNavigator(DatabaseProduct product) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(
          product: product,
          addBloc: _addBloc,
          isEditable: true,
          isNewProduct: true,
        ),
      ),
    );
  }

  _tileContent(DatabaseProduct product, Nutriments nutriments) {
    return Expanded(
      flex: 72,
      child: Row(
        children: [
          Expanded(
            flex: 75,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  product.name ?? "no info",
                  softWrap: true,
                ),
                _subtitleListTile(product, nutriments),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _trailingListTile(product, nutriments),
            ],
          ),
        ],
      ),
    );
  }

  Widget _subtitleListTile(DatabaseProduct product, Nutriments nutriments) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[
          TextSpan(
            text: _showValue(
                "protein: ", nutriments.proteinPerServing.toString()),
            style: searchListStyle,
          ),
          TextSpan(
            text: _showValue(" carbs: ", nutriments.carbsPerServing.toString()),
            style: searchListStyle,
          ),
          TextSpan(
            text: _showValue(" fat: ", nutriments.fatsPerServing.toString()),
            style: searchListStyle,
          ),
        ],
      ),
    );
  }

  Widget _trailingListTile(DatabaseProduct product, Nutriments nutriments) {
    String servingUnit = product.servingUnit;
    return Column(
      children: [
        Text(
          _showValue("kcal: ", nutriments.caloriesPerServing.toString()),
          style: searchListStyle,
        ),
        Text(
          _showValue(
              "kcal 100$servingUnit: ", nutriments.caloriesPer100g.toString()),
          style: searchListStyle,
        ),
      ],
    );
  }

  String _showValue(String name, String value) {
    if (value == 'null' || value == "-1.0") {
      return name + '?';
    }
    return name + value;
  }
}
