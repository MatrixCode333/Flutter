import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projrct/presentation/home/bloc/home_screen_bloc.dart';
import 'package:projrct/presentation/home/controller/home_screen_controller.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => HomeScreenBloc(context),
    child: HomeScreenController(),
    );
  }
}
