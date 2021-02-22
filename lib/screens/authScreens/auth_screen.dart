import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lifestylediet/bloc/authBloc/bloc.dart';
import 'package:lifestylediet/blocProviders/bloc_providers.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/repositories/repositories.dart';
import 'package:lifestylediet/screens/screens.dart';
import 'package:lifestylediet/utils/common_utils.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthBloc _bloc;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String uid = "";
  DateFormat dateFormat = new DateFormat("yyyy-MM-dd");
  String strDate;

  @override
  initState() {
    super.initState();
    _bloc = BlocProvider.of<AuthBloc>(context);
    _bloc.add(LoginLoad());
    strDate = dateFormat.format(DateTime.now());
    _portraitModeOnly();
  }

  void _portraitModeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: appTheme(),
        child: _getStreamBuilder(),
      ),
    );
  }

  _getStreamBuilder() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        return _getFutureBuilder(snapshot);
      },
    );
  }

  _getFutureBuilder(snapshot) {
    return FutureBuilder(
      future: _getPersonalData(),
      builder: (_, snap) {
        if (snapshot.hasData) {
          return _userIsLoggedIn(snapshot, snap);
        } else {
          return LoginScreen(scaffoldKey: _scaffoldKey);
        }
      },
    );
  }

  _userIsLoggedIn(snapshot, snap) {
    if (snapshot.data.emailVerified) {
      return _userHasVerifiedEmail(snapshot, snap);
    } else {
      return LoginScreen(scaffoldKey: _scaffoldKey);
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
    if (snap.data.goal != "") {
      return HomeProvider(uid: snapshot.data.uid, currentDate: strDate);
    } else {
      return PersonalDataScreen(bloc: _bloc);
    }
  }

  _getPersonalData() async {
    DatabaseUserRepository _databaseUserRepository =
        DatabaseUserRepository(uid: uid);
    PersonalData _personalData =
        await _databaseUserRepository.getUserPersonalData();
    return _personalData ??
        new PersonalData("", "", "", "", "", "", "", "", "");
  }
}
