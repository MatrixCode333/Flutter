import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../damain/usecases/login_usecase.dart';
import '../../damain/usecases/signup_usecase.dart';


part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;

  LoginBloc(
      this.loginUseCase,
      this.signupUseCase,
      ) : super(LoginInitial()) {

    on<SignupButtonPressed>((event, emit) async {
      emit(LoginLoading());

      try {

        // Create auth user
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        final uid = credential.user!.uid;

        final database = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL:
          "https://codetrax-8fd48-default-rtdb.firebaseio.com",
        );

        await database.ref().child("users").child(uid).set({
          "name": event.name,
          "email": event.email,
        });
        emit(LoginSuccess());

      } on FirebaseAuthException catch (e) {
        emit(LoginFailure(e.message ?? "Signup Failed"));
      } catch (e) {
        emit(LoginFailure(e.toString()));
      }
    });
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());

      try {
        await loginUseCase(
          event.email,
          event.password,
        );

        emit(LoginSuccess());
      } catch (e) {
        emit(LoginFailure(e.toString()));
      }
    });
  }
}