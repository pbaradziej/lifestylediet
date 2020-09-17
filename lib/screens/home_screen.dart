import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/BlocProviders/home.dart';
import 'login_screen.dart';
import '../blocs/loginBloc/bloc.dart';

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
        } else {
          return Scaffold(
            appBar: appBar(),
            body: HomeProvider(),
          );
        }
      },
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
}
