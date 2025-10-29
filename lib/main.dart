import 'package:flutter/material.dart';
import 'package:projrct/presentation/home/view%20/screen/home_screen.dart' show HomeScreen;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //SizeConfig().initialize(context);
    MaterialColor mycolor = MaterialColor(
      const Color.fromRGBO(248, 195, 5, 1).value,
      const <int, Color>{
        50: Color.fromRGBO(248, 195, 5, 0.1),
        100: Color.fromRGBO(248, 195, 5, 0.2),
        200: Color.fromRGBO(248, 195, 5, 0.3),
        300: Color.fromRGBO(248, 195, 5, 0.4),
        400: Color.fromRGBO(248, 195, 5, 0.5),
        500: Color.fromRGBO(248, 195, 5, 0.6),
        600: Color.fromRGBO(248, 195, 5, 0.7),
        700: Color.fromRGBO(248, 195, 5, 0.8),
        800: Color.fromRGBO(248, 195, 5, 0.9),
        900: Color.fromRGBO(248, 195, 5, 1),
      },
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Loan Application',
      theme: ThemeData(
        primarySwatch: mycolor,
      ),
      home: HomeScreen(),
    );
  }
}