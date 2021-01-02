import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/bloc/registerBloc/bloc.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/utils/common_utils.dart';
import 'loading_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _rememberMe = false;
  bool _acceptTerms = false;
  String _email;
  String _password;
  RegisterBloc _bloc;

  @override
  initState() {
    super.initState();
    _bloc = BlocProvider.of<RegisterBloc>(context);
    load();
  }

  load() {
    _bloc.add(RegisterLoad());
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: appTheme(),
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (content, state) {
          if (state is RegisterLoading) {
            return loadingScreen();
          } else if (state is RegisterLoaded) {
            return registerBuilder(state, node);
          } else if (state is ReturnLogin) {
            return LoginScreen();
          } else if (state is RegisterFailure) {
            return registerBuilder(state, node);
          } else {
            return loadingScreen();
          }
        },
      ),
    );
  }

  Widget registerBuilder(state, FocusScopeNode node) {
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
                Center(
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                loginTF(state, node),
                SizedBox(height: 20),
                passwordTF(state),
                SizedBox(height: 10),
                acceptConditions(),
                SizedBox(height: 20),
                signUp(state),
                SizedBox(height: 10),
                Text(
                  "- OR -",
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 20),
                login(),
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
            decoration: new InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              errorText: state is RegisterFailure ? 'Enter an email' : '',
              errorStyle: TextStyle(fontSize: 12, height: 0.3),
              prefixIcon: Icon(
                Icons.mail,
                color: Colors.white60,
              ),
              hintText: "Enter Email",
              hintStyle: TextStyle(color: Colors.white60),
              border: new OutlineInputBorder(
                borderSide: state is RegisterFailure
                    ? BorderSide(color: Colors.red)
                    : BorderSide.none,
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10),
                ),
              ),
              filled: true,
              fillColor: appTextFieldsColor,
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
          child: TextFormField(
            obscureText: true,
            onChanged: (password) {
              setState(() {
                _password = password;
              });
            },
            // textInputAction: TextInputAction.next,
            style: TextStyle(
              color: Colors.white,
              height: 2,
            ),
            decoration: new InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              errorText: state is RegisterFailure
                  ? 'Enter a password 6+ chars long'
                  : '',
              errorStyle: TextStyle(fontSize: 12, height: 0.3),
              prefixIcon: Icon(
                Icons.vpn_key,
                color: Colors.white60,
              ),
              hintText: "Enter Password",
              hintStyle: TextStyle(color: Colors.white60),
              border: new OutlineInputBorder(
                borderSide: state is RegisterFailure
                    ? BorderSide(color: Colors.red)
                    : BorderSide.none,
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10),
                ),
              ),
              filled: true,
              fillColor: appTextFieldsColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget acceptConditions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14.0, 0, 0, 0),
      child: Container(
        height: 20,
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Theme(
              data: ThemeData(
                unselectedWidgetColor: _acceptTerms ? Colors.red : Colors.white,
              ),
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
              "Accept Conditions",
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

  Widget signUp(state) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      margin: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: RaisedButton(
        disabledColor: Colors.grey,
        padding: EdgeInsets.all(15),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        color: Colors.white,
        onPressed: () {
          setState(() {
            _rememberMe ? registerUser() : _acceptTerms = true;
          });
        },
        child: Text(
          "Sign Up",
          style: TextStyle(color: Colors.black45),
        ),
      ),
    );
  }

  Widget login() {
    return GestureDetector(
      onTap: () {
        _bloc.add(Return());
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Return to",
              style: TextStyle(color: Colors.white70),
            ),
            TextSpan(text: " Login")
          ],
        ),
      ),
    );
  }

  registerUser() {
    Users _user = Users(_email.trim(), _password);
    Register _register = Register(user: _user);
    _bloc.add(_register);
  }
}
