import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/bloc/authBloc/bloc.dart';
import 'package:lifestylediet/blocProviders/bloc_providers.dart';
import 'package:lifestylediet/components/components.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/screens/screens.dart';
import 'package:lifestylediet/utils/common_utils.dart';

class LoginScreen extends StatefulWidget {
  final scaffoldKey;

  const LoginScreen({Key key, this.scaffoldKey}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthBloc _bloc;
  bool _hidePassword = true;
  final FocusNode _passFocus = FocusNode();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _checkboxController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool registerPopped = false;
  bool verifyEmail = false;
  String uid = "";

  @override
  initState() {
    super.initState();
    _bloc = BlocProvider.of<AuthBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (content, state) {
        if (state is LoginLoading) {
          return loadingScreen();
        } else if (state is LoginSuccess) {
          _rememberMeController();
          return HomeProvider(uid: state.uid, currentDate: state.currentDate);
        } else if (state is LoginLoaded) {
          return _loginScreen(state, node);
        } else if (state is RegisterSuccess) {
          return _registerSuccess(state);
        } else if (state is LoginFailure) {
          return _loginScreen(state, node);
        } else if (state is ConfirmEmail) {
          return _snackBar(state.message, state.scaffoldKey);
        } else if (state is VerifyEmail) {
          return _snackBar(state.message, widget.scaffoldKey);
        } else if (state is RegisterState) {
          return _snackBar(state.message, state.scaffoldKey);
        } else if (state is PersonalDataState) {
          return PersonalDataScreen(bloc: _bloc);
        } else if (state is PersonalDataResult) {
          return GoalsScreen(bloc: _bloc);
        } else {
          return loadingScreen();
        }
      },
    );
  }

  Widget _registerSuccess(state) {
    if (!registerPopped) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
      registerPopped = true;
    }
    return _snackBar(state.message, widget.scaffoldKey);
  }

  Widget _loginScreen(state, FocusScopeNode node) {
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
                  _loginTF(state, node),
                  SizedBox(height: 20),
                  _passwordTF(state, node),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      rememberMe(),
                      _forgotPassword(),
                    ],
                  ),
                  _login(),
                  SizedBox(height: 10),
                  Text("- OR -", style: loginMenuHintStyle),
                  SizedBox(height: 20),
                  _signUp(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginTF(state, FocusScopeNode node) {
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
        color: iconTrailingColors,
      ),
    );
  }

  Widget _passwordTF(state, FocusScopeNode node) {
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
      borderSide: state is LoginFailure,
    );
  }

  Widget _forgotPassword() {
    return Container(
      padding: const EdgeInsets.only(right: 14),
      child: FlatButton(
        onPressed: () {
          return Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ForgotPasswordScreen(bloc: _bloc),
            ),
          );
        },
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

  _snackBar(String message, GlobalKey<ScaffoldState> scaffoldKey) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(message),
      ));
    });

    _bloc.add(LoginLoad());
    return Container();
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

  Widget _signUp() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterScreen(bloc: _bloc),
          ),
        );
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: "Don\'t have an account?", style: loginMenuHintStyle),
            TextSpan(text: " Sign up")
          ],
        ),
      ),
    );
  }

  Widget _login() {
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
