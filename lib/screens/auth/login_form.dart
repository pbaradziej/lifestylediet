import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/components/logic_component.dart';
import 'package:lifestylediet/components/raised_button.dart';
import 'package:lifestylediet/components/text_form_field.dart';
import 'package:lifestylediet/cubits/login/login_cubit.dart';
import 'package:lifestylediet/screens/auth/forgot_password_screen.dart';
import 'package:lifestylediet/utils/fonts.dart';
import 'package:lifestylediet/utils/palette.dart';

class LoginForm extends StatefulWidget {
  final String email;

  const LoginForm({
    required this.email,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late LoginCubit loginCubit;
  late bool hidePassword;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController checkboxController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  LoginState get loginState => loginCubit.state;

  LoginStatus get loginStatus => loginState.status;

  @override
  void initState() {
    super.initState();
    loginCubit = context.read();
    hidePassword = true;
    emailController = TextEditingController(text: widget.email);
    passwordController = TextEditingController();
    checkboxController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final FocusScopeNode node = FocusScope.of(context);
    return NotificationListener<OverscrollIndicatorNotification>(
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
                  Text('Lifestyle Diet', style: titleStyle),
                  const SizedBox(height: 30),
                  loginField(node),
                  const SizedBox(height: 20),
                  passwordField(node),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      rememberMe(),
                      forgotPassword(),
                    ],
                  ),
                  loginButton(),
                  const SizedBox(height: 10),
                  Text('- OR -', style: loginMenuHintStyle),
                  const SizedBox(height: 20),
                  signUpButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loginField(FocusScopeNode node) {
    return TextFormFieldComponent(
      label: 'Email',
      controller: emailController,
      hintText: 'Enter Email',
      borderSide: loginStatus == LoginStatus.loginError,
      errorText: loginStatus == LoginStatus.loginError ? 'Invalid email' : '',
      minCharacters: 3,
      minCharactersMessage: 'Enter an email 3+ chars long',
      onEditingComplete: () => node.nextFocus(),
      prefixIcon: Icon(
        Icons.mail,
        color: iconTrailingColors,
      ),
    );
  }

  Widget passwordField(FocusScopeNode node) {
    return TextFormFieldComponent(
      label: 'Password',
      controller: passwordController,
      obscureText: hidePassword,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => onPressed(),
      errorText: loginStatus == LoginStatus.loginError ? 'Invalid password' : '',
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
      borderSide: loginStatus == LoginStatus.loginError,
    );
  }

  Widget rememberMe() {
    return LogicComponent(
      label: 'Remember me',
      controller: checkboxController,
    );
  }

  Widget forgotPassword() {
    return Container(
      padding: const EdgeInsets.only(right: 14),
      child: ElevatedButton(
        onPressed: onForgotPasswordPressed,
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }

  void onForgotPasswordPressed() {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: forgotPasswordBuilder,
      ),
    );
  }

  Widget forgotPasswordBuilder(BuildContext context) {
    return BlocProvider<LoginCubit>.value(
      value: loginCubit,
      child: ForgotPasswordScreen(),
    );
  }

  Widget loginButton() {
    return RaisedButtonComponent(
      label: 'Login',
      onPressed: onPressed,
    );
  }

  void onPressed() {
    final FormState? currentState = formKey.currentState;
    final bool hasNoErrors = currentState?.validate() ?? false;
    if (hasNoErrors) {
      loginToApplication();
    }
  }

  void loginToApplication() {
    final String email = getEmail();
    final String password = passwordController.text;
    loginCubit.login(email, password);
  }

  String getEmail() {
    final String email = emailController.text;
    return email.trim();
  }

  Widget signUpButton() {
    return GestureDetector(
      onTap: onTap,
      child: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(text: "Don\'t have an account?", style: loginMenuHintStyle),
            const TextSpan(text: ' Sign up')
          ],
        ),
      ),
    );
  }

  void onTap() {
    loginCubit.registerUser();
  }
}
