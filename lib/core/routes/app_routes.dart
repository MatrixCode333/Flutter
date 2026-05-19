import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projrct/features/auth/damain/repositories/auth_repository.dart';
import 'package:projrct/features/auth/presentation/bloc/login_bloc.dart';

import '../../features/auth/damain/usecases/login_usecase.dart';
import '../../features/auth/damain/usecases/signup_usecase.dart';
import '../../features/auth/data/datasource/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/presentation/sign_up_login_screen/sign_up_login_screen.dart';
import '../../features/home_screen/domain/repositories/home_repository.dart';
import '../../features/home_screen/presentation/bloc/home_bloc.dart';
import '../../features/home_screen/presentation/bloc/home_event.dart';
import '../../features/home_screen/presentation/pages/screen/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AppRoutes {
  static const String initial = '/';
  static const String homeScreen = '/home-screen';
  static const String signUpLoginScreen = '/sign-up-login-screen';
  static const String categoriesScreen = '/categories-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) =>  BlocProvider(
      create: (_) => LoginBloc(
        LoginUseCase(
          AuthRepositoryImpl(
            AuthRemoteDataSource(
              FirebaseAuth.instance,
            ),
          ),
        ),SignupUseCase(AuthRepositoryImpl(
        AuthRemoteDataSource(
          FirebaseAuth.instance,
        ),
      )),
      ),
      child: SignUpLoginScreen(),
    )
    ,homeScreen: (context) => BlocProvider(
      create: (_) =>  HomeBloc(
        HomeRepository(),
      )..add(LoadUserEvent()),

      child: const HomeScreen(),
    ),
    signUpLoginScreen: (context) => const SignUpLoginScreen(),
    // categoriesScreen: (context) => const CategoriesScreen(),
  };
}
