import 'package:flutter/material.dart';
import 'package:lifestylediet/bloc/authBloc/bloc.dart';
import 'package:lifestylediet/components/components.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/utils/common_utils.dart';
import 'package:lifestylediet/screens/screens.dart';

class RegisterScreen extends StatefulWidget {
  final AuthBloc bloc;

  const RegisterScreen({Key key, this.bloc}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _acceptedConditions = true;
  bool _hidePassword = true;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _checkboxController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  AuthBloc _bloc;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc;
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: appTheme(),
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowGlow();
          },
          child: Center(
            child: ListView(
              shrinkWrap: true,
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
                      loginTF(node),
                      SizedBox(height: 20),
                      passwordTF(),
                      SizedBox(height: 10),
                      acceptConditions(),
                      SizedBox(height: 20),
                      signUp(),
                      SizedBox(height: 10),
                      Text("- OR -", style: loginMenuHintStyle),
                      SizedBox(height: 20),
                      login(),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loginTF(FocusScopeNode node) {
    return TextFormFieldComponent(
      label: "Email",
      controller: _emailController,
      hintText: "Enter Email",
      minCharacters: 3,
      minCharactersMessage: "Enter an email 3+ chars long",
      onEditingComplete: () => node.nextFocus(),
      prefixIcon: Icon(
        Icons.mail,
        color: iconTrailingColors,
      ),
    );
  }

  Widget passwordTF() {
    return TextFormFieldComponent(
      label: "Password",
      controller: _passwordController,
      obscureText: _hidePassword,
      textInputAction: TextInputAction.done,
      minCharacters: 6,
      minCharactersMessage: "Enter a password 6+ chars long",
      suffixIcon: IconButton(
        color: iconTrailingColors,
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
        color: iconTrailingColors,
      ),
      hintText: "Enter Password",
    );
  }

  Widget acceptConditions() {
    return LogicComponent(
      label: "Accept Conditions",
      navigate: () => _navigateTermsOfConditions(),
      controller: _checkboxController,
      validationEnabled: _acceptedConditions,
    );
  }

  _navigateTermsOfConditions() {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TermsOfConditions(),
      ),
    );
  }

  Widget signUp() {
    return RaisedButtonComponent(
      label: "Sign Up",
      onPressed: () {
        setState(() {
          if (_formKey.currentState.validate()) {
            Users _user = Users(
              _emailController.text?.trim(),
              _passwordController.text,
            );
            _bloc.add(Register(user: _user, scaffoldKey: _scaffoldKey));
          }
        });
      },
    );
  }

  Widget login() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Return to",
              style: loginMenuHintStyle,
            ),
            TextSpan(text: " Login")
          ],
        ),
      ),
    );
  }
}
