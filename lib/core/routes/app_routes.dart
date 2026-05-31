import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/damain/repositories/auth_repository.dart';
import '../../features/auth/damain/usecases/login_usecase.dart';
import '../../features/auth/damain/usecases/signup_usecase.dart';
import '../../features/auth/data/datasource/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/presentation/bloc/login_bloc.dart';
import '../../features/auth/presentation/sign_up_login_screen/sign_up_login_screen.dart';
import '../../features/home_screen/domain/repositories/home_repository.dart';
import '../../features/home_screen/presentation/bloc/home_bloc.dart';
import '../../features/home_screen/presentation/bloc/home_event.dart';
import '../../features/home_screen/presentation/pages/screen/home_screen.dart';
import '../../features/home_screen/presentation/pages/screen/wedding_invitation_screen.dart';

class AppRoutes {
  static const String initial                 = '/';
  static const String homeScreen              = '/home-screen';
  static const String signUpLoginScreen       = '/sign-up-login-screen';
  static const String categoriesScreen        = '/categories-screen';  // ✅ add back
  static const String weddingInvitationScreen = '/wedding-invitation-screen';

  // ... rest unchanged


  /// Call this once in main.dart to wrap MaterialApp with the shared HomeBloc.
  ///
  /// Example:
  ///   runApp(AppRoutes.wrapWithProviders(child: MyApp()));
  static Widget wrapWithProviders({required Widget child}) {
    return MultiBlocProvider(
      providers: [
        // HomeBloc lives above the Navigator — visible to every named route.
        BlocProvider<HomeBloc>(
          create: (_) => HomeBloc(HomeRepository())..add(LoadUserEvent()),
        ),

        // LoginBloc is also app-level so SignUpLoginScreen can reach it
        // both as the initial route and via /sign-up-login-screen.
        BlocProvider<LoginBloc>(
          create: (_) => LoginBloc(
            LoginUseCase(
              AuthRepositoryImpl(AuthRemoteDataSource(FirebaseAuth.instance)),
            ),
            SignupUseCase(
              AuthRepositoryImpl(AuthRemoteDataSource(FirebaseAuth.instance)),
            ),
          ),
        ),
      ],
      child: child,
    );
  }

  static Map<String, WidgetBuilder> routes = {
    // ── No BlocProvider wrappers needed here anymore ──────────────────────
    // Every screen below automatically inherits the blocs provided above.

    initial:                  (_) => const SignUpLoginScreen(),
    homeScreen:               (_) => const HomeScreen(),
    signUpLoginScreen:        (_) => const SignUpLoginScreen(),
    weddingInvitationScreen:  (_) => const WeddingInvitationScreen(), // ✅ fixed
  };
}