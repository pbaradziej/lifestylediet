import 'package:flutter/material.dart';
import 'package:lifestylediet/components/components.dart';
import 'package:lifestylediet/cubits/login/login_cubit.dart';
import 'package:lifestylediet/utils/fonts.dart';
import 'package:lifestylediet/utils/palette.dart';
import 'package:lifestylediet/utils/theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late LoginCubit loginCubit;
  late GlobalKey<FormState> formKey;
  late FocusNode emailFocus;
  late TextEditingController emailController;
  late GlobalKey<ScaffoldState> scaffoldKey;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    emailFocus = FocusNode();
    emailController = TextEditingController();
    scaffoldKey = GlobalKey<ScaffoldState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: appTheme(),
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowIndicator();
            return false;
          },
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 20),
                      Text('Reset Password', style: titleStyle),
                      const SizedBox(height: 30),
                      emailField(),
                      sendEmail(),
                      const SizedBox(height: 10),
                      Text('- OR -', style: loginMenuHintStyle),
                      const SizedBox(height: 20),
                      signUp(),
                      const SizedBox(height: 20),
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

  Widget emailField() {
    return TextFormFieldComponent(
      label: 'Email',
      controller: emailController,
      hintText: 'Email Your Email',
      minCharacters: 3,
      minCharactersMessage: 'Enter an email 3+ chars long',
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => onFieldSubmitted(),
      prefixIcon: Icon(
        Icons.mail,
        color: iconTrailingColors,
      ),
    );
  }

  Widget sendEmail() {
    return RaisedButtonComponent(
      label: 'Send Email',
      halfScreen: true,
      onPressed: onFieldSubmitted,
    );
  }

  void onFieldSubmitted() {
    final FormState? currentState = formKey.currentState;
    final bool hasNoErrors = currentState?.validate() ?? false;
    if (hasNoErrors) {
      emailFocus.unfocus();
      final String email = emailController.text;
      loginCubit.resetPassword(email);
    }
  }

  Widget signUp() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(text: 'Return to', style: loginMenuHintStyle),
            const TextSpan(text: ' Login'),
          ],
        ),
      ),
    );
  }
}
