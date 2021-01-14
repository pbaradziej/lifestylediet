import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import 'package:lifestylediet/blocProviders/bloc_providers.dart';
import 'package:lifestylediet/bloc/loginBloc/bloc.dart';
import 'package:lifestylediet/components/components.dart';
import 'package:lifestylediet/components/raised_button.dart';
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
  bool _hidePassword = true;
  final FocusNode _passFocus = FocusNode();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

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
              return PersonalDataScreen(
                email: "s",
                password: "s",
              );
              //return RegisterProvider();
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
    return TextFormFieldComponent(
      label: "Email",
      controller: _emailController,
      hintText: "Enter Email",
      borderSide: state is LoginFailure,
      errorText: state is LoginFailure ? 'invalid email' : '',
      onEditingComplete: () => node.nextFocus(),
      prefixIcon: Icon(
        Icons.mail,
        color: Colors.white60,
      ),
    );
  }

  Widget passwordTF(state, FocusScopeNode node) {
    return TextFormFieldComponent(
      label: "Password",
      controller: _passwordController,
      obscureText: _hidePassword,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) {
        _passFocus.unfocus();
        Users user = new Users(
          _emailController.text.trim(),
          _passwordController.text,
        );
        _bloc.add(Login(user: user));
        _rememberMeController();
      },
      errorText: state is LoginFailure ? 'invalid password' : '',
      suffixIcon: IconButton(
        color: Colors.white60,
        onPressed: () {
          setState(() {
            _hidePassword = !_hidePassword;
          });
        },
        icon: Icon(
          _hidePassword ? Icons.visibility_off : Icons.visibility,
        ),
      ),
      prefixIcon: Icon(
        Icons.vpn_key,
        color: Colors.white60,
      ),
      hintText: "Enter Password",
      borderSide: state is LoginFailure,
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
    return LogicComponent(
      label: "Remember me",
      value: _rememberMe,
    );
  }

  _rememberMeController() {
    if(!_rememberMe) {
      _emailController.clear();
    }

    _passwordController.clear();
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
    return RaisedButtonComponent(
      label: "Login",
      onPressed:  () {
        Users user = new Users(
          _emailController.text.trim(),
          _passwordController.text,
        );
        _bloc.add(Login(user: user));
        _rememberMeController();
      },
    );
  }
}
