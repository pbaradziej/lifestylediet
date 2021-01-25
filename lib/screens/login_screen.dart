import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/bloc/loginBloc/bloc.dart';
import 'package:lifestylediet/blocProviders/bloc_providers.dart';
import 'package:lifestylediet/components/components.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/screens/screens.dart';
import 'package:lifestylediet/utils/common_utils.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc _bloc;
  bool _hidePassword = true;
  final FocusNode _passFocus = FocusNode();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _checkboxController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
            } else if (state is RegisterLoadingState) {
              return RegisterProvider();
            } else if (state is LoginSuccess) {
              _rememberMeController();
              return HomeProvider(
                  uid: state.uid, currentDate: state.currentDate);
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
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Text('Lifestyle Diet', style: titleStyle),
                  SizedBox(height: 30),
                  loginTF(state, node),
                  SizedBox(height: 20),
                  passwordTF(state, node),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      rememberMe(),
                      //forgotPassword(),
                    ],
                  ),
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
      errorText: state is LoginFailure ? 'Invalid email' : null,
      minCharacters: 3,
      minCharactersMessage: "Enter an email 3+ chars long",
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
        if (_formKey.currentState.validate()) {
          Users user = new Users(
            _emailController.text.trim(),
            _passwordController.text,
          );
          _bloc.add(Login(user: user));
          _rememberMeController();
        }
      },
      errorText: state is LoginFailure ? 'Invalid password' : null,
      minCharacters: 6,
      minCharactersMessage: "Enter an email 6+ chars long",
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
      controller: _checkboxController,
    );
  }

  _rememberMeController() {
    if (_checkboxController.text == 'true') {
      _emailController.clear();
    }

    _passwordController.clear();
  }

  Widget signUp() {
    return GestureDetector(
      onTap: () {
        _bloc.add(RegisterLoadEvent());
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
      onPressed: () {
        if (_formKey.currentState.validate()) {
          Users user = new Users(
            _emailController.text.trim(),
            _passwordController.text,
          );
          _bloc.add(Login(user: user));
        }
      },
    );
  }
}
