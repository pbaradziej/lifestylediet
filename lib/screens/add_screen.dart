import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/bloc/addBloc/bloc.dart';
import 'package:lifestylediet/bloc/homeBloc/bloc.dart';
import 'package:lifestylediet/bloc/loginBloc/bloc.dart';
import 'package:lifestylediet/models/food.dart';
import 'package:lifestylediet/screens/details_screen.dart';
import 'package:lifestylediet/screens/home_screen.dart';
import 'package:lifestylediet/screens/loading_screen.dart';
import 'package:lifestylediet/themeAccent/theme.dart';
import 'package:openfoodfacts/model/Product.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  AddBloc _addBloc;
  String _search;
  HomeBloc _homeBloc;
  LoginBloc _loginBloc;
  String _scanBarcode = 'Unknown';
  Food food = Food();

  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    _addBloc = BlocProvider.of<AddBloc>(context);
    super.initState();
  }

  _getFoodList(String search) {
    _addBloc.add(SearchFood(search));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Column(
        children: [
          appBar(),
          searchTF(),
          BlocBuilder<AddBloc, AddState>(
            builder: (context, state) {
              if (state is AddReturnState) {
                return HomeScreen();
              } else if (state is AddLoadedState) {
                return _adderCards();
              } else if (state is AddLoadingState) {
                return Column(
                  children: [
                    SizedBox(height: 150),
                    loadingScreen(),
                  ],
                );
              } else if (state is AddSearchState) {
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      return showFood(state, index);
                    },
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }

  _onWillPop() {
    _addBloc.add(AddReturn());
  }

  Widget appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.orangeAccent,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () => _addBloc.add(AddReturn()),
      ),
    );
  }

  Widget searchTF() {
    return Container(
      alignment: Alignment.centerLeft,
      width: 330,
      child: TextField(
        textInputAction: TextInputAction.search,
        onChanged: (search) {
          setState(() {
            _search = search;
            if (_search == '') {
              _addBloc.add(InitialScreen());
            }
          });
        },
        onSubmitted: (submit) => _getFoodList(_search),
        style: TextStyle(
          color: Colors.black,
          height: 2,
        ),
        decoration: new InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 10.0,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black45,
            ),
            onPressed: () => _getFoodList(_search),
          ),
          hintText: "Search product",
          hintStyle: TextStyle(color: Colors.grey),
          border: new OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black45,
            ),
            borderRadius: const BorderRadius.all(
              const Radius.circular(10),
            ),
          ),
          filled: true,
          fillColor: searchTextFields(),
        ),
      ),
    );
  }

  _scanner() async {
    await scanBarcodeNormal();
    Product product;
    try {
      product = await food.getProduct(_scanBarcode);
    } catch (Exception) {}
    if (product != null) {
      _navigateToDetailsScreen(product);
    } else {
      _snackBar();
    }
  }

  _navigateToDetailsScreen(Product product) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(
          product: product,
          meal: _homeBloc.meal,
          uid: _loginBloc.uid,
          addBloc: _addBloc,
        ),
      ),
    );
  }

  _snackBar() {
    final snackBar = SnackBar(
      content: Text('Product not found!'),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  Widget _adderCards() {
    return Column(
      children: [
        SizedBox(height: 15),
        Row(
          children: [
            _barcodeScanner(),
            databaseProducts(),
          ],
        ),
      ],
    );
  }

  Widget _barcodeScanner() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _scanner();
        },
        child: Container(
          height: 170,
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    SizedBox(width: 16),
                    IconButton(
                      icon: Icon(
                        Icons.filter_center_focus,
                        size: 120,
                        color: Colors.orange,
                      ),
                      onPressed: () {},
                    ),
                    SizedBox(width: 10),
                  ],
                ),
                SizedBox(height: 70),
                Text(
                  'Scanner',
                  style: TextStyle(fontSize: 19),
                ),
                SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget databaseProducts() {
    return Expanded(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: 170,
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    SizedBox(width: 16),
                    IconButton(
                      icon: Icon(
                        Icons.list,
                        size: 120,
                        color: Colors.orange,
                      ),
                      onPressed: () {},
                    ),
                    SizedBox(width: 10),
                  ],
                ),
                SizedBox(height: 70),
                Text(
                  'Get from database',
                  style: TextStyle(fontSize: 19),
                ),
                SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget showFood(AddSearchState state, int index) {
    Product product = state.products[index];
    final nutriments = product.nutriments;

    return Container(
      height: 100,
      child: Card(
        child: InkWell(
          onTap: () => _detailsNavigator(product),
          child: Row(
            children: [
              Expanded(
                flex: 22,
                child: Image.network(product.selectedImages[2].url),
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

  _detailsNavigator(Product product) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(
          product: product,
          meal: _homeBloc.meal,
          uid: _loginBloc.uid,
          addBloc: _addBloc,
        ),
      ),
    );
  }

  _tileContent(Product product, final nutriments) {
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
                  product.productNameEN ??
                      product.productName ??
                      product.productNameFR ??
                      product.productNameDE ??
                      "no info",
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

  Widget _subtitleListTile(final product, final nutriments) {
    return Row(
      children: [
        _showValue("protein: ", nutriments.carbohydrates.toString()),
        _showValue(" carbs: ", nutriments.carbohydrates.toString()),
        _showValue(" fat: ", nutriments.carbohydrates.toString()),
      ],
    );
  }

  Widget _trailingListTile(final product, final nutriments) {
    return Column(
      children: [
        _showValue("kcal: ", nutriments.energyServing.toString()),
        _showValue("kcal 100g: ", nutriments.energyKcal100g.toString()),
      ],
    );
  }

  Widget _showValue(String name, String value) {
    if (value == 'null') {
      return Text(name + '?', style: TextStyle(fontSize: 11));
    }
    return Text(name + value, style: TextStyle(fontSize: 11));
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }
}
