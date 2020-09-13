import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_screen.dart';
import '../loginBloc/bloc.dart';
import '../themeAccent/theme.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LoginBloc _bloc;

  @override
  initState() {
    super.initState();
    _bloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (content, state) {
        if (state is Logout) {
          return LoginScreen();
        } else if (state is LoginSuccess) {
          return Scaffold(
            appBar: appBar(),
            body: Column(
              children: [
                calories(),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Column(
                        children: [
                          breakfast(),
                          dinner(),
                          supper(),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget breakfast() {
    return SizedBox(
      height: 65,
      width: 340,
      child: Card(
        child: ListTile(
          title: Text('Breakfast'),
          trailing: IconButton(
            icon: Icon(Icons.add),
            onPressed: null,
          ),
        ),
      ),
    );
  }

  Widget dinner() {
    return SizedBox(
      height: 65,
      width: 340,
      child: Card(
        child: ListTile(
          title: Text('Dinner'),
          trailing: IconButton(
            icon: Icon(Icons.add),
            onPressed: null,
          ),
        ),
      ),
    );
  }

  Widget supper() {
    return SizedBox(
      height: 65,
      width: 340,
      child: Card(
        child: ListTile(
          title: Text('Supper'),
          trailing: IconButton(
            icon: Icon(Icons.add),
            onPressed: null,
          ),
        ),
      ),
    );
  }

  Widget calories() {
    return Container(
      height: 250,
      alignment: Alignment.topCenter,
      decoration: menuTheme(),
      child: Container(
        width: 350,
        child: Column(
          children: [
            SizedBox(height: 20),
            kcalRow(),
            SizedBox(height: 26),
            nutritionRow(),
          ],
        ),
      ),
    );
  }

  Widget appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.orangeAccent,
      leading: IconButton(
        icon: Icon(
          Icons.account_circle,
          color: Colors.white,
        ),
        onPressed: null,
      ),
      actions: [
        logout(),
      ],
    );
  }

  Widget logout() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 3, 0, 0),
      child: FlatButton(
        onPressed: () {
          _bloc.add(Logout());
        },
        child: Text(
          'Logout',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget kcalRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(width: 0),
        kcalLeft(),
        SizedBox(width: 20),
        kcal(),
        SizedBox(width: 20),
        kcalTaken(),
      ],
    );
  }

  Widget nutritionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        fats(),
        protein(),
        carbs(),
      ],
    );
  }

  Widget kcalLeft() {
    return Column(
      children: [
        Text(
          'kcal',
          style: subTitleStyle(),
        ),
        Text(
          'left',
          style: subTitleStyle(),
        ),
        Text(
          '0',
          style: subTitleStyle(),
        )
      ],
    );
  }

  Widget kcal() {
    return Column(
      children: [
        Text(
          'kcal',
          style: titleStyle(),
        ),
        Text(
          '0',
          style: titleStyle(),
        )
      ],
    );
  }

  Widget kcalTaken() {
    return Column(
      children: [
        Text(
          'kcal',
          style: subTitleStyle(),
        ),
        Text(
          'taken',
          style: subTitleStyle(),
        ),
        Text(
          '0',
          style: subTitleStyle(),
        )
      ],
    );
  }

  Widget fats() {
    return Column(
      children: [
        Text('Fats', style: textStyle()),
        SizedBox(
          height: 5,
        ),
        Text('0', style: textStyle()),
      ],
    );
  }

  Widget protein() {
    return Column(
      children: [
        Text('Protein', style: textStyle()),
        SizedBox(
          height: 5,
        ),
        Text('0', style: textStyle()),
      ],
    );
  }

  Widget carbs() {
    return Column(
      children: [
        Text('Carbs', style: textStyle()),
        SizedBox(
          height: 5,
        ),
        Text('0', style: textStyle()),
      ],
    );
  }
}
