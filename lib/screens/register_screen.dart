import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/bloc/registerBloc/bloc.dart';
import 'package:lifestylediet/components/components.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/screens/screens.dart';
import 'package:lifestylediet/utils/common_utils.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _acceptedConditions = true;
  bool _hidePassword = true;
  RegisterBloc _bloc;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _checkboxController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
          } else if (state is RegisterResult) {
            return _registerResult(state, node);
          } else if (state is PersonalDataResult) {
            return GoalsScreen(bloc: _bloc);
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
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: Text('Sign Up', style: titleStyle),
                  ),
                  SizedBox(height: 30),
                  loginTF(node, state),
                  SizedBox(height: 20),
                  passwordTF(state),
                  SizedBox(height: 10),
                  acceptConditions(),
                  SizedBox(height: 20),
                  signUp(state),
                  SizedBox(height: 10),
                  Text("- OR -", style: TextStyle(color: Colors.white70)),
                  SizedBox(height: 20),
                  login(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _registerResult(RegisterResult state, node) {
    if (state.result) {
      return PersonalDataScreen(bloc: _bloc);
    } else {
      return registerBuilder(state, node);
    }
  }

  Widget loginTF(FocusScopeNode node, state) {
    return TextFormFieldComponent(
      label: "Email",
      controller: _emailController,
      hintText: "Enter Email",
      minCharacters: 3,
      minCharactersMessage: "Enter an email 3+ chars long",
      borderSide: state is RegisterResult,
      errorText: state is RegisterResult ? 'invalid email' : null,
      onEditingComplete: () => node.nextFocus(),
      prefixIcon: Icon(
        Icons.mail,
        color: Colors.white60,
      ),
    );
  }

  Widget passwordTF(state) {
    return TextFormFieldComponent(
      label: "Password",
      controller: _passwordController,
      obscureText: _hidePassword,
      textInputAction: TextInputAction.done,
      minCharacters: 6,
      minCharactersMessage: "Enter a password 6+ chars long",
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
      borderSide: state is RegisterResult,
    );
  }

  Widget acceptConditions() {
    return LogicComponent(
      label: "Accept Conditions",
      controller: _checkboxController,
      validationEnabled: _acceptedConditions,
    );
  }

  Widget signUp(state) {
    return RaisedButtonComponent(
      label: "Sign Up",
      onPressed: () {
        setState(() {
          if (_formKey.currentState.validate()) {
            Users _user = Users(
              _emailController.text?.trim(),
              _passwordController.text,
            );
            Register _register = Register(user: _user);
            _bloc.add(_register);
          }
        });
      },
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
}
