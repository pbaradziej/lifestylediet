import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/bloc/addBloc/bloc.dart';
import 'package:lifestylediet/screens/screens.dart';
import 'package:lifestylediet/utils/common_utils.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  AddBloc _addBloc;

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
              SearchField(),
              BlocBuilder<AddBloc, AddState>(
                builder: (context, state) {
                  if (state is AddReturnState) {
                    return HomeScreen();
                  } else if (state is AddLoadedState) {
                    return _adderCards();
                  } else if (state is ProductNotFoundState) {
                    return _snackBar();
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

  Widget loadingScreenFlex() {
    return Flexible(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 50),
        children: [
          loadingScreen(),
        ],
      ),
    );
  }
}
