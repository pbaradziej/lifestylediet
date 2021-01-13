import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import 'package:lifestylediet/blocProviders/bloc_providers.dart';
import 'package:lifestylediet/bloc/loginBloc/bloc.dart';
import 'package:lifestylediet/utils/common_utils.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/screens/screens.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  LoginBloc _bloc;
  String _email;
  String _password;
  bool _showPassword = true;
  final FocusNode _passFocus = FocusNode();

  @override
  initState() {
    super.initState();
    _bloc = BlocProvider.of<LoginBloc>(context);
    _loadLogin();
    _portraitModeOnly();
  }

  void _portraitModeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  _loadLogin() {
    _bloc.add(LoginLoad());
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: appTheme(),
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (content, state) {
            if (state is LoginLoading) {
              return loadingScreen();
            } else if (state is RegisterLoading) {
              return RegisterProvider();
            } else if (state is LoginSuccess) {
              return HomeProvider();
            } else if (state is LoginLoaded) {
              return loginScreen(state, node);
            } else if (state is LoginFailure) {
              return loginScreen(state, node);
            } else {
              return loadingScreen();
            }
          },
        ),
      ),
    );
  }

  Widget loginScreen(state, FocusScopeNode node) {
    return Center(
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowGlow();
        },
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text('Lifestyle Diet', style: titleStyle),
                SizedBox(height: 30),
                loginTF(state, node),
                SizedBox(height: 20),
                passwordTF(state, node),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    rememberMe(),
                    forgotPassword(),
                  ],
                ),
                //rememberMe(),
                login(),
                SizedBox(height: 10),
                Text(
                  "- OR -",
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 20),
                signUp(),
                SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget loginTF(state, FocusScopeNode node) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Email", style: TextStyle(color: Colors.white)),
        Container(
          alignment: Alignment.centerLeft,
          width: 260,
          child: TextFormField(
            onChanged: (login) {
              setState(() {
                _email = login;
              });
            },
            textInputAction: TextInputAction.next,
            onEditingComplete: () => node.nextFocus(),
            style: TextStyle(
              color: Colors.white,
              height: 2,
            ),
            decoration: loginDecoration(state),
          ),
        ),
      ],
    );
  }

  InputDecoration loginDecoration(state) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      errorText: state is LoginFailure ? 'invalid email' : '',
      errorStyle: TextStyle(fontSize: 12, height: 0.3),
      prefixIcon: Icon(
        Icons.mail,
        color: Colors.white60,
      ),
      hintText: "Enter Email",
      hintStyle: TextStyle(color: Colors.white60),
      border: new OutlineInputBorder(
        borderSide: state is LoginFailure
            ? BorderSide(color: Colors.red)
            : BorderSide.none,
        borderRadius: const BorderRadius.all(
          const Radius.circular(10),
        ),
      ),
      filled: true,
      fillColor: appTextFieldsColor,
    );
  }

  Widget passwordTF(state, FocusScopeNode node) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Password", style: TextStyle(color: Colors.white)),
        Container(
          alignment: Alignment.centerLeft,
          width: 260,
          child: TextFormField(
            obscureText: _showPassword,
            onChanged: (password) {
              setState(() {
                _password = password;
              });
            },
            textInputAction: TextInputAction.done,
            focusNode: _passFocus,
            onFieldSubmitted: (value) {
              _passFocus.unfocus();
              Users user = new Users(_email.trim(), _password);
              _bloc.add(Login(user: user));
            },
            style: TextStyle(
              color: Colors.white,
              height: 2,
            ),
            decoration: passwordDecoration(state),
          ),
        ),
      ],
    );
  }

  InputDecoration passwordDecoration(state) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      errorText: state is LoginFailure ? 'invalid password' : '',
      errorStyle: TextStyle(fontSize: 12, height: 0.3),
      suffixIcon: IconButton(
        color: Colors.white60,
        onPressed: () {
          setState(() {
            _showPassword = !_showPassword;
          });
        },
        icon: Icon(
          _showPassword ? Icons.visibility_off : Icons.visibility,
        ),
      ),
      prefixIcon: Icon(
        Icons.vpn_key,
        color: Colors.white60,
      ),
      hintText: "Enter Password",
      hintStyle: TextStyle(color: Colors.white60),
      border: new OutlineInputBorder(
        borderSide: state is LoginFailure
            ? BorderSide(color: Colors.red)
            : BorderSide.none,
        borderRadius: const BorderRadius.all(
          const Radius.circular(10),
        ),
      ),
      filled: true,
      fillColor: appTextFieldsColor,
    );
  }

  Widget forgotPassword() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () {},
        child: Text(
          "Forgot Password?",
          style: TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }

  Widget rememberMe() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14.0, 0, 0, 0),
      child: Container(
        height: 20,
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Theme(
              data: ThemeData(unselectedWidgetColor: Colors.white),
              child: Checkbox(
                value: _rememberMe,
                checkColor: Colors.green,
                activeColor: Colors.white,
                onChanged: (bool value) {
                  setState(() {
                    _rememberMe = value;
                  });
                },
              ),
            ),
            Text(
              "Remember me",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget signUp() {
    return GestureDetector(
      onTap: () {
        _bloc.add(Register());
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: "Don\'t have an account?",
                style: TextStyle(color: Colors.white70)),
            TextSpan(text: " Sign up")
          ],
        ),
      ),
    );
  }

  Widget login() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      margin: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: RaisedButton(
        padding: EdgeInsets.all(15),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        color: Colors.white,
        onPressed: () {
          Users user = new Users(_email.trim(), _password);
          _bloc.add(Login(user: user));
        },
        child: Text(
          "Login",
          style: TextStyle(color: Colors.black45),
        ),
      ),
    );
  }
}
