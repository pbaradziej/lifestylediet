import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_screen.dart';
import '../loginBloc/bloc.dart';

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
            appBar: AppBar(
              title: Text('Login App'),
              actions: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 3, 0, 0),
                  child: FlatButton(
                    onPressed: () {
                      _bloc.add(Logout());
                    },
                    child: Text(
                      'Logout',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
            body: Center(
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(0, 3, 0, 0),
                child: Text(
                  'Hello, ' + state.user.email,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
