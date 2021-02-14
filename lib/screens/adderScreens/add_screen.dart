import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/bloc/addBloc/bloc.dart';
import 'package:lifestylediet/bloc/authBloc/bloc.dart';
import 'package:lifestylediet/components/components.dart';
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
  TextEditingController _searchController = TextEditingController();
  ProductRepository _productRepository = new ProductRepository();

  @override
  void initState() {
    _addBloc = BlocProvider.of<AddBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: defaultColor,
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
              _searchField(),
              BlocBuilder<AddBloc, AddState>(
                builder: (context, state) {
                  if (state is AddReturnState) {
                    return HomeScreen();
                  } else if (state is AddLoadedState) {
                    return _adderCards();
                  } else if (state is ProductNotFoundState) {
                    return _snackBar('Product not found!');
                  } else if (state is DatabaseProductsState) {
                    return DatabaseListScreen(products: state.products);
                  } else if (state is AddLoadingState) {
                    return loadingScreen();
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

  _onWillPop() {
    _addBloc.add(AddReturn());
  }

  Widget _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: backgroundColor,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: defaultColor,
        ),
        onPressed: () => _addBloc.add(AddReturn()),
      ),
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
              Flexible(flex: 1, child: BarcodeScanner()),
              Flexible(flex: 1, child: DatabaseProducts()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _searchField() {
    return TextFormFieldComponent(
      onChangedParameter: _onChangedParameter(),
      searchField: true,
      controller: _searchController,
      hintText: "Search products...",
      onFieldSubmitted: (_) => _getSearchProductList(_searchController.text),
      suffixIcon: IconButton(
        icon: Icon(
          Icons.search,
          color: defaultBorderColor,
        ),
        onPressed: () => _getSearchProductList(_searchController.text),
      ),
      textInputAction: TextInputAction.search,
    );
  }

  _onChangedParameter() {
    if (_searchController.text == '') {
      _addBloc.add(InitialScreen());
    }
  }

  _getSearchProductList(String search) async {
    _addBloc.add(SearchProduct(search));
    List<DatabaseProduct> products;
    try {
      products = await _productRepository.getSearchProducts(search);
    } catch (Exception) {
      setState(() {
        return _snackBar('Product not found!');
      });
    }
    int productsListSize = products?.length ?? 0;
    if (productsListSize > 1) {
      return _multiDetailsNavigator(products);
    } else if (productsListSize == 1) {
      return _detailsNavigator(products.first);
    }
  }

  Widget _snackBar(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Scaffold.of(context)
        ..showSnackBar(SnackBar(
          content: Text(message),
        ));
    });
    _addBloc.add(InitialScreen());
    return Container();
  }

  _multiDetailsNavigator(List<DatabaseProduct> products) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiDetailsScreen(
          products: products,
          meal: _addBloc.meal,
          currentDate: _addBloc.currentDate,
          uid: _addBloc.uid,
          addBloc: _addBloc,
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
}
