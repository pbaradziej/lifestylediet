import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/bloc/addBloc/bloc.dart';
import 'package:lifestylediet/bloc/homeBloc/bloc.dart';
import 'package:lifestylediet/bloc/loginBloc/bloc.dart';
import 'package:lifestylediet/screens/details_screen.dart';
import 'package:lifestylediet/screens/home_screen.dart';
import 'package:lifestylediet/screens/loading_screen.dart';
import 'package:lifestylediet/themeAccent/theme.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  AddBloc _addBloc;
  String _search;
  HomeBloc _homeBloc;
  LoginBloc _loginBloc;

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
    return Column(
      children: [
        appBar(),
        searchTF(),
        BlocBuilder<AddBloc, AddState>(
          builder: (context, state) {
            if (state is AddReturnState) {
              return HomeScreenData();
            } else if (state is AddLoadedState) {
              return Container();
            } else if (state is AddLoadingState) {
              return loadingScreen();
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
    );
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

  Widget showFood(AddSearchState state, int index) {
    final product = state.products[index];
    final nutriments = product.nutriments;

    return Card(
      child: ListTile(
        subtitle: _subtitleListTile(product, nutriments),
        title: Text(
          product.productNameEN ?? product.productName ?? "",
        ),
        trailing: _trailingListTile(product, nutriments),
        leading: Image.network(product.selectedImages[2].url),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(
              product: product,
              meal: _homeBloc.meal,
              uid: _loginBloc.uid,
              addBloc: _addBloc,
            ),
          ),
        ),
      ),
    );
  }

  Widget _subtitleListTile(final product, final nutriments) {
    return Row(
      children: [
        _showValue("carbs: ", nutriments.carbohydrates.toString()),
        _showValue(" protein: ", nutriments.carbohydrates.toString()),
        _showValue(" fats: ", nutriments.carbohydrates.toString()),
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
}
