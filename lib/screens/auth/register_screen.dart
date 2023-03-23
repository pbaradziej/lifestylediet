import 'package:flutter/material.dart';
import 'package:lifestylediet/components/components.dart';
import 'package:lifestylediet/cubits/login/login_cubit.dart';
import 'package:lifestylediet/screens/auth/terms_of_conditions.dart';
import 'package:lifestylediet/utils/fonts.dart';
import 'package:lifestylediet/utils/palette.dart';
import 'package:lifestylediet/utils/theme.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late LoginCubit loginCubit;
  late bool hidePassword;
  late GlobalKey<FormState> formKey;
  late GlobalKey<ScaffoldState> scaffoldKey;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController checkboxController;

  @override
  void initState() {
    super.initState();
    hidePassword = true;
    formKey = GlobalKey<FormState>();
    scaffoldKey = GlobalKey<ScaffoldState>();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    checkboxController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final FocusScopeNode node = FocusScope.of(context);
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
                    children: <Widget>[
                      const SizedBox(height: 20),
                      Center(
                        child: Text('Sign Up', style: titleStyle),
                      ),
                      const SizedBox(height: 30),
                      loginField(node),
                      const SizedBox(height: 20),
                      passwordField(),
                      const SizedBox(height: 10),
                      acceptConditions(),
                      const SizedBox(height: 20),
                      signUp(),
                      const SizedBox(height: 10),
                      Text('- OR -', style: loginMenuHintStyle),
                      const SizedBox(height: 20),
                      login(),
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

  Widget loginField(FocusScopeNode node) {
    return TextFormFieldComponent(
      label: 'Email',
      controller: emailController,
      hintText: 'Enter Email',
      minCharacters: 3,
      minCharactersMessage: 'Enter an email 3+ chars long',
      onEditingComplete: () => node.nextFocus(),
      prefixIcon: Icon(
        Icons.mail,
        color: iconTrailingColors,
      ),
    );
  }

  Widget passwordField() {
    return TextFormFieldComponent(
      label: 'Password',
      controller: passwordController,
      obscureText: hidePassword,
      textInputAction: TextInputAction.done,
      minCharacters: 6,
      minCharactersMessage: 'Enter a password 6+ chars long',
      suffixIcon: IconButton(
        color: iconTrailingColors,
        onPressed: () {
          setState(() {
            hidePassword = !hidePassword;
          });
        },
        icon: Icon(
          hidePassword ? Icons.visibility_off : Icons.visibility,
        ),
      ),
      prefixIcon: Icon(
        Icons.vpn_key,
        color: iconTrailingColors,
      ),
      hintText: 'Enter Password',
    );
  }

  Widget acceptConditions() {
    return LogicComponent(
      label: 'Accept Conditions',
      navigate: navigateTermsOfConditions,
      controller: checkboxController,
      validationEnabled: true,
    );
  }

  void navigateTermsOfConditions() {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => TermsOfConditions(),
      ),
    );
  }

  Widget signUp() {
    return RaisedButtonComponent(
      label: 'Sign Up',
      onPressed: onPressed,
    );
  }

  void onPressed() {
    final FormState? currentState = formKey.currentState;
    final bool hasNoErrors = currentState?.validate() ?? false;
    if (hasNoErrors) {
      registerUser();
    }
  }

  void registerUser() {
    final String email = getEmail();
    final String password = passwordController.text;
    loginCubit.register(email, password);
  }

  String getEmail() {
    final String email = emailController.text;
    return email.trim();
  }

  Widget login() {
    return GestureDetector(
      onTap: onBackToLoginPressed,
      child: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: 'Return to',
              style: loginMenuHintStyle,
            ),
            const TextSpan(text: ' Login')
          ],
        ),
      ),
    );
  }

  void onBackToLoginPressed() {
    loginCubit.initializeAuthentication();
  }
}
