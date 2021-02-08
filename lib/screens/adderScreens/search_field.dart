import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/bloc/addBloc/bloc.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/repositories/repositories.dart';
import 'package:lifestylediet/screens/screens.dart';
import 'package:lifestylediet/utils/common_utils.dart';

class SearchField extends StatefulWidget {
  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  AddBloc _addBloc;
  ProductRepository _productRepository = new ProductRepository();
  String _search;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _addBloc = BlocProvider.of<AddBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          style: searchTextStyle,
          decoration: _searchDecoration(),
        ),
      ),
    );
  }

  InputDecoration _searchDecoration() {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 10.0,
      ),
      suffixIcon: IconButton(
        icon: Icon(
          Icons.search,
          color: defaultBorderColor,
        ),
        onPressed: () {
          _getFoodList(_search);
        },
      ),
      hintText: "Search products...",
      hintStyle: TextStyle(color: Colors.grey),
      border: new OutlineInputBorder(
        borderSide: BorderSide(
          color: defaultBorderColor,
        ),
        borderRadius: const BorderRadius.all(
          const Radius.circular(10),
        ),
      ),
      filled: true,
      fillColor: searchLupe,
    );
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
