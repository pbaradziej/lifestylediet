import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/BlocProviders/register.dart';
import 'package:lifestylediet/blocs/loginBloc/bloc.dart';
import 'package:lifestylediet/themeAccent/theme.dart';
import 'package:lifestylediet/models/models.dart';
import 'home_screen.dart';
import 'loading_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  LoginBloc _bloc;
  String _login;
  String _password;

  @override
  initState() {
    super.initState();
    _bloc = BlocProvider.of<LoginBloc>(context);
    _loadLogin();
  }

  _loadLogin() {
    _bloc.add(LoginLoad());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            return HomeScreen();
          } else if (state is LoginLoaded) {
            return loginScreen(state);
          } else if (state is LoginFailure) {
            return loginScreen(state);
          } else {
            return loadingScreen();
          }
        },
      ),
    );
  }

  Widget loginScreen(state) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 100),
          Text(
            'Lifestyle Diet',
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 30),
          loginTF(state),
          SizedBox(height: 20),
          passwordTF(state),
          forgotPassword(),
          rememberMe(),
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
        ],
      ),
    );
  }

  Widget loginTF(state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Email", style: TextStyle(color: Colors.white)),
        Container(
          alignment: Alignment.centerLeft,
          width: 260,
          child: TextField(
            onChanged: (login) {
              setState(() {
                _login = login;
              });
            },
            style: TextStyle(
              color: Colors.white,
              height: 2,
            ),
            decoration: new InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              errorText: state is LoginFailure ? 'invalid email' : '',
              errorStyle: TextStyle(fontSize: 12, height: 0.3),
              prefixIcon: Icon(
                Icons.mail,
                color: Colors.white60,
              ),
              hintText: "Enter your Email",
              hintStyle: TextStyle(color: Colors.white60),
              border: new OutlineInputBorder(
                borderSide: state is LoginFailure
                    ? BorderSide(color: Colors.red)
                    : BorderSide.none,
                borderRadius: const BorderRadius.all(const Radius.circular(10)),
              ),
              filled: true,
              fillColor: appTextFields(),
            ),
          ),
        ),
      ],
    );
  }

  Widget passwordTF(state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Password", style: TextStyle(color: Colors.white)),
        Container(
          alignment: Alignment.centerLeft,
          width: 260,
          child: TextField(
            obscureText: true,
            onChanged: (password) {
              setState(() {
                _password = password;
              });
            },
            style: TextStyle(
              color: Colors.white,
              height: 2,
            ),
            decoration: new InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              errorText: state is LoginFailure ? 'invalid password' : '',
              errorStyle: TextStyle(fontSize: 12, height: 0.3),
              prefixIcon: Icon(
                Icons.vpn_key,
                color: Colors.white60,
              ),
              hintText: "Enter your Password",
              hintStyle: TextStyle(color: Colors.white60),
              border: new OutlineInputBorder(
                borderSide: state is LoginFailure
                    ? BorderSide(color: Colors.red)
                    : BorderSide.none,
                borderRadius: const BorderRadius.all(const Radius.circular(10)),
              ),
              filled: true,
              fillColor: appTextFields(),
            ),
          ),
        ),
      ],
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
        _bloc.add(RegisterLoad());
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: Colors.white,
        onPressed: () {
          _bloc.add(
            Login(
              user: Users(_login, _password),
            ),
          );
        },
        child: Text(
          "Login",
          style: TextStyle(color: Colors.black45),
        ),
      ),
    );
  }
}
