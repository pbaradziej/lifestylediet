import 'package:flutter/material.dart';
import 'package:lifestylediet/bloc/authBloc/bloc.dart';
import 'package:lifestylediet/components/components.dart';
import 'package:lifestylediet/utils/common_utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final AuthBloc bloc;

  const ForgotPasswordScreen({Key key, this.bloc}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  AuthBloc _bloc;
  final FocusNode _emailFocus = FocusNode();
  static final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  initState() {
    super.initState();
    _bloc = widget.bloc;
  }

  @override
  Widget build(BuildContext context) {
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      Text('Reset Password', style: titleStyle),
                      SizedBox(height: 30),
                      _emailTF(),
                      _sendEmail(),
                      SizedBox(height: 10),
                      Text("- OR -", style: loginMenuHintStyle),
                      SizedBox(height: 20),
                      signUp(),
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

  Widget _emailTF() {
    return TextFormFieldComponent(
      label: "Email",
      controller: _emailController,
      hintText: "Email Your Email",
      minCharacters: 3,
      minCharactersMessage: "Enter an email 3+ chars long",
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) {
        if (_formKey.currentState.validate()) {
          _emailFocus.unfocus();
          AuthEvent event = ResetPassword(_emailController.text, _scaffoldKey);
          _bloc.add(event);
        }
      },
      prefixIcon: Icon(
        Icons.mail,
        color: iconTrailingColors,
      ),
    );
  }

  Widget _sendEmail() {
    return RaisedButtonComponent(
      label: "Send Email",
      halfScreen: true,
      onPressed: () {
        if (_formKey.currentState.validate()) {
          _emailFocus.unfocus();
          AuthEvent event = ResetPassword(_emailController.text, _scaffoldKey);
          _bloc.add(event);
        }
      },
    );
  }

  Widget signUp() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: "Return to", style: loginMenuHintStyle),
            TextSpan(text: " Login")
          ],
        ),
      ),
    );
  }
}
