import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:lifestylediet/bloc/addBloc/bloc.dart';
import 'package:lifestylediet/bloc/homeBloc/bloc.dart';
import 'package:lifestylediet/bloc/loginBloc/bloc.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/repositories/repositories.dart';
import 'package:lifestylediet/screens/screens.dart';
import 'package:lifestylediet/utils/common_utils.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  AddBloc _addBloc;
  String _search;
  HomeBloc _homeBloc;
  LoginBloc _loginBloc;
  String _barcode = 'Unknown';
  ProductRepository _productRepository = new ProductRepository();

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    _addBloc = BlocProvider.of<AddBloc>(context);
  }

  _getFoodList(String search) async {
    List<DatabaseProduct> products;
    _addBloc.add(SearchFood(search));
    try {
      products = await _productRepository.getSearchProducts(search);
    } catch (Exception) {
      setState(() {
        return _snackBar();
      });
    }
    int productsListSize = products?.length ?? 0;
    if (productsListSize > 1) {
      return _multiDetailsNavigator(products);
    } else if (productsListSize == 1) {
      return _detailsNavigator(products.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: WillPopScope(
        onWillPop: () => _onWillPop(),
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowGlow();
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _appBar(),
              searchTF(),
              BlocBuilder<AddBloc, AddState>(
                builder: (context, state) {
                  if (state is AddReturnState) {
                    return HomeScreen();
                  } else if (state is AddLoadedState) {
                    return _adderCards();
                  } else if (state is ProductNotFoundState) {
                    return _snackBar();
                  } else if (state is AddLoadingState) {
                    return Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 50),
                        children: [
                          loadingScreen(),
                        ],
                      ),
                    );
                  } else if (state is AddSearchState) {
                    List<DatabaseProduct> products = state.products;
                    int productsListSize = products.length;
                    if (productsListSize > 1) {
                      return _multiDetailsNavigator(products);
                    } else if (productsListSize == 1) {
                      return _detailsNavigator(products.first);
                    } else {
                      return _snackBar();
                    }
                    // return _searchListBuilder(state);
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _multiDetailsNavigator(List<DatabaseProduct> products) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiDetailsScreen(
          products: products,
          meal: _homeBloc.meal,
          uid: _loginBloc.uid,
          addBloc: _addBloc,
        ),
      ),
    );
  }

  _onWillPop() {
    _addBloc.add(AddReturn());
  }

  Widget _appBar() {
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

  Widget _searchListBuilder(AddSearchState state) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        itemCount: state.products.length,
        itemBuilder: (context, index) {
          return showFood(state, index);
        },
      ),
    );
  }

  Widget _snackBar() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Scaffold.of(context)
        ..showSnackBar(SnackBar(
          content: Text('Product not found!'),
        ));
    });
    _addBloc.add(InitialScreen());
    return Container();
  }

  Widget searchTF() {
    return Container(
      alignment: Alignment.centerLeft,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8),
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
          onSubmitted: (submit) {
            _getFoodList(_search);
          },
          style: TextStyle(
            color: Colors.black,
            height: 2,
          ),
          decoration: searchDecoration(),
        ),
      ),
    );
  }

  InputDecoration searchDecoration() {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 10.0,
      ),
      suffixIcon: IconButton(
        icon: Icon(
          Icons.search,
          color: Colors.black45,
        ),
        onPressed: () {
          _getFoodList(_search);
        },
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
      fillColor: searchLupe,
    );
  }

  Widget _adderCards() {
    return Flexible(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(0),
        children: [
          Row(
            children: [
              Flexible(flex: 1, child: _barcodeScanner()),
              Flexible(flex: 1, child: _databaseProducts()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _barcodeScanner() {
    return GestureDetector(
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
                  SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      Icons.filter_center_focus,
                      size: 120,
                      color: Colors.orange,
                    ),
                    onPressed: () {},
                  ),
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
    );
  }

  _scanner() async {
    await scanBarcodeNormal();
    DatabaseProduct product;
    try {
      product = await _productRepository.getProductFromBarcode(_barcode);
    } catch (Exception) {}
    if (product != null) {
      _detailsNavigator(product);
    } else {
      _snackBar();
    }
  }

  Widget _databaseProducts() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 170,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      Icons.list,
                      size: 120,
                      color: Colors.orange,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 50),
              Text(
                'Get from database',
                style: TextStyle(fontSize: 19),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget showFood(AddSearchState state, int index) {
    DatabaseProduct product = state.products[index];
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
          meal: _homeBloc.meal,
          uid: _loginBloc.uid,
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
      _barcode = barcodeScanRes;
    });
  }
}
