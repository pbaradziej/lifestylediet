import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/cubits/auth/auth_cubit.dart';
import 'package:lifestylediet/cubits/login/login_cubit.dart';
import 'package:lifestylediet/cubits/product/product_cubit.dart';
import 'package:lifestylediet/cubits/routing/routing_cubit.dart';
import 'package:lifestylediet/screens/auth/login_screen.dart';
import 'package:lifestylediet/screens/home/home_screen.dart';
import 'package:lifestylediet/screens/loading_screens.dart';
import 'package:lifestylediet/utils/theme.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late AuthCubit cubit;
  late ConnectionState connectionState;

  @override
  void initState() {
    super.initState();
    cubit = context.read();
    connectionState = ConnectionState.waiting;
    portraitModeOnly();
  }

  void portraitModeOnly() {
    SystemChrome.setPreferredOrientations(
      <DeviceOrientation>[
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: appTheme(),
        child: authStreamBuilder(),
      ),
    );
  }

  Widget authStreamBuilder() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: buildAuthScreen,
    );
  }

  Widget buildAuthScreen(final BuildContext context, final AsyncSnapshot<User?> userData) {
    final User? user = userData.data;
    final bool hasVerifiedEmail = user?.emailVerified ?? false;
    if(connectionState == ConnectionState.waiting) {
      connectionState = userData.connectionState;
    }

    if (connectionState == ConnectionState.waiting) {
      return loadingScreen();
    } else if (!hasVerifiedEmail) {
      return loginScreen();
    }

    return authCubitBuilder();
  }

  Widget authCubitBuilder() {
    cubit.initializeAuthentication();
    return BlocBuilder<AuthCubit, AuthState>(
      builder: builder,
    );
  }

  Widget builder(final BuildContext _, final AuthState state) {
    final AuthStatus status = state.status;
    if (status == AuthStatus.initial) {
      return loadingScreen();
    } else if (state.canLogin) {
      return homeScreen();
    } else {
      return loginScreen();
    }
  }

  Widget homeScreen() {
    return MultiBlocProvider(
      providers: providers(),
      child: const HomeScreen(),
    );
  }

  List<BlocProvider<BlocBase<Object>>> providers() {
    return <BlocProvider<BlocBase<Object>>>[
      BlocProvider<RoutingCubit>(
        create: (final BuildContext content) => RoutingCubit(),
      ),
      BlocProvider<ProductCubit>(
        create: (final BuildContext content) => ProductCubit(),
      ),
    ];
  }

  Widget loginScreen() {
    return BlocProvider<LoginCubit>(
      create: (final BuildContext content) => LoginCubit(),
      child: LoginScreen(),
    );
  }
}
