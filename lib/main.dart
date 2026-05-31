// main.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/routes/app_routes.dart';
import 'features/auth/presentation/sign_up_login_screen/sign_up_login_screen.dart';
import 'features/home_screen/presentation/pages/widgets/invatation /public_invitation_widget.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    AppRoutes.wrapWithProviders(   // ✅ THIS was missing — wraps the entire app
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.initial,
      routes: AppRoutes.routes,
      onGenerateRoute: (settings) {
        if (settings.name != null &&
            settings.name!.startsWith('/invitation/')) {

          final id = settings.name!.replaceFirst('/invitation/', '');

          if (id.isEmpty) {
            return MaterialPageRoute(
              builder: (_) => const SignUpLoginScreen(),
            );
          }

          return MaterialPageRoute(
            builder: (_) => PublicInvitationScreen(
              userId: "E12QROygwTS9ZDGt3KT7gzbvAhB2",
            ),
          );
        }

        return MaterialPageRoute(
          builder: (_) => const SignUpLoginScreen(),
        );
      },
    );
  }
}