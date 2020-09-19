import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/bloc/addBloc/bloc.dart';
import 'package:lifestylediet/screens/details_screen.dart';
import 'package:lifestylediet/screens/home_screen.dart';
import 'package:lifestylediet/screens/loading_screen.dart';
import 'package:lifestylediet/themeAccent/theme.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  AddBloc _bloc;
  String _search;

  @override
  void initState() {
    _bloc = BlocProvider.of<AddBloc>(context);
    super.initState();
  }

  _getFoodList(String search) {
    _bloc.add(SearchFood(search));
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
        onPressed: () => _bloc.add(AddReturn()),
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
    return Card(
      child: ListTile(
        subtitle: Text("carbs: " +
            state.products[index].nutriments.carbohydrates.toString() +
            " protein: " +
            state.products[index].nutriments.proteins.toString() +
            " fats: " +
            state.products[index].nutriments.fat.toString()),
        title: Text(
          state.products[index].productNameEN ??
              state.products[index].productName ??
              "",
        ),
        trailing: Text("kcal: " +
            state.products[index].nutriments.energyServing.toString() +
            "\nkcal 100g: " +
            state.products[index].nutriments.energyKcal100g.toString()),
        leading: Image.network(state.products[index].selectedImages[2].url),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(
              product: state.products[index],
            ),
          ),
        ),
      ),
    );
  }
}
