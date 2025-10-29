import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projrct/presentation/home/bloc/home_screen_event.dart';
import 'package:projrct/presentation/home/bloc/home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent,HomeScreenState>{

  BuildContext context;
  HomeScreenBloc(this.context): super(InitialHomeScreenState());

  Stream<HomeScreenState> mapEventToState(HomeScreenEvent event) async* {
  }
}

