import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lifestylediet/bloc/authBloc/bloc.dart';
import 'package:lifestylediet/blocProviders/bloc_providers.dart';
import 'package:lifestylediet/components/components.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/repositories/repositories.dart';
import 'package:lifestylediet/screens/screens.dart';
import 'package:lifestylediet/utils/common_utils.dart';

class LoginScreen extends StatefulWidget {
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool registerPopped = false;
  bool verifyEmail = false;
  String uid = "";

  @override
  initState() {
    super.initState();
    _bloc = BlocProvider.of<AuthBloc>(context);
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
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: appTheme(),
        child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, snapshot) {
            return _getFutureBuilder(snapshot);
          },
        ),
      ),
    );
  }

  _getFutureBuilder(snapshot) {
    return FutureBuilder(
      future: _getPersonalData(),
      builder: (_, snap) {
        if (!snapshot.hasData) {
          return _getBlocBuilder();
        } else {
          return _userIsLogged(snapshot, snap);
        }
      },
    );
  }

  _userIsLogged(snapshot, snap) {
    if (snapshot.data.emailVerified) {
      return _userHasVerifiedEmail(snapshot, snap);
    } else {
      return _getBlocBuilder();
    }
  }

  _userHasVerifiedEmail(snapshot, snap) {
    uid = snapshot.data.uid;
    if (snap.hasData) {
      return _userHasPersonalData(snapshot, snap);
    } else {
      return loadingScreen();
    }
  }

  _userHasPersonalData(snapshot, snap) {
    if (snap.data.sex != "") {
      DateFormat dateFormat = new DateFormat("yyyy-MM-dd");
      String strDate = dateFormat.format(DateTime.now());
      return HomeProvider(uid: snapshot.data.uid, currentDate: strDate);
    } else {
      return _getBlocBuilder();
    }
  }

  _getPersonalData() async {
    DatabaseUserRepository _databaseUserRepository =
        DatabaseUserRepository(uid: uid);
    PersonalData _personalData =
        await _databaseUserRepository.getUserPersonalData();
    return _personalData ?? new PersonalData("", "", "", "", "", "", "", "");
  }

  Widget _getBlocBuilder() {
    final node = FocusScope.of(context);
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (content, state) {
        if (state is LoginLoading) {
          return loadingScreen();
        } else if (state is LoginSuccess) {
          _rememberMeController();
          return HomeProvider(uid: state.uid, currentDate: state.currentDate);
        } else if (state is LoginLoaded) {
          return loginScreen(state, node);
        } else if (state is RegisterSuccess) {
          if (!registerPopped) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pop(context);
            });
            registerPopped = true;
          }
          return _snackBar(state.message, _scaffoldKey);
        } else if (state is LoginFailure) {
          return loginScreen(state, node);
        } else if (state is ConfirmEmail) {
          return _snackBar(state.message, state.scaffoldKey);
        } else if (state is VerifyEmail) {
          return _snackBar(state.message, _scaffoldKey);
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      rememberMe(),
                      forgotPassword(),
                    ],
                  ),
                  login(),
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
        color: iconTrailingColors,
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

  Widget forgotPassword() {
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

  Widget signUp() {
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
