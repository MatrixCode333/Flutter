import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projrct/presentation/home/bloc/home_screen_bloc.dart';
import 'package:projrct/presentation/home/bloc/home_screen_state.dart';
import 'package:projrct/presentation/home/view%20/screen/home_screen.dart';

class HomeScreenController extends StatelessWidget {
  const HomeScreenController({super.key});

  static HomeScreenBloc? homeScreenBloc;
  @override
  Widget build(BuildContext context) {
    homeScreenBloc = BlocProvider.of<HomeScreenBloc>(context);

    return Scaffold(

      body: BlocConsumer<HomeScreenBloc,HomeScreenState>(
        listener: (context,state){

        },
        bloc: homeScreenBloc,
        builder: (context,state){
          return HomeScreen();
        }
      ),
    );
  }
}
