import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifestylediet/themeAccent/theme.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class DetailsScreen extends StatefulWidget {
  final Product product;

  DetailsScreen({this.product});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  String _dropdownValue = 'serving';

  @override
  Widget build(BuildContext context) {
    String _dropdownValue;

    return Scaffold(
      appBar: appBar(context),
      body: Container(
        child: Column(
          children: [
            titleBox(),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 30),
                Image.network(widget.product.selectedImages[1].url),
                SizedBox(width: 30),
                kcal(),
              ],
            ),
            nutriments(),
          ],
        ),
      ),
    );
  }

  Widget kcal() {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                child: TextFormField(
                  initialValue: '1',
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black45),
                      ),
                      hintText: 'servings'),
                  textAlign: TextAlign.center,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
              SizedBox(width: 20),
              DropdownButton(
                value: _dropdownValue,
                onChanged: (newValue) {
                  setState(() {
                    _dropdownValue = newValue;
                  });
                },
                items:
                    <String>['serving', '100g'].map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
              ),
            ],
          ),
          SizedBox(height: 30),
          Text("Calories per serving"),
          Text(
            widget.product.nutriments.energyServing.toString(),
            style: subTitleAddScreenStyle(),
          ),
          SizedBox(height: 30),
          Text("Calories per 100g"),
          Text(
            widget.product.nutriments.energyKcal100g.toString(),
            style: subTitleAddScreenStyle(),
          ),
        ],
      ),
    );
  }

  Widget nutriments() {
    return Column(
      children: [
        Text(
          "carbs: " + widget.product.nutriments.carbohydrates.toString(),
          style: subTitleAddScreenStyle(),
        ),
        Text(
          "protein: " + widget.product.nutriments.proteins.toString(),
          style: subTitleAddScreenStyle(),
        ),
        Text(
          "fats: " + widget.product.nutriments.fat.toString(),
          style: subTitleAddScreenStyle(),
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
                    widget.product.productName,
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
    );
  }
}
