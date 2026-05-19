import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../domain/repositories/home_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  final HomeRepository repository;

  HomeBloc(this.repository)
      : super(HomeState.initial()) {

    on<LoadUserEvent>(_onLoadUser);

    on<ChangeCategoryEvent>((event, emit) {
      emit(
        state.copyWith(
          selectedCategory: event.category,
        ),
      );
    });

    on<ChangeBottomNavEvent>((event, emit) {
      emit(
        state.copyWith(
          currentNavIndex: event.index,
        ),
      );
    });

    on<ToggleWishlistEvent>((event, emit) {

      final updatedProducts =
      state.products.map((product) {

        if (product.id == event?.productId) {

          product.isWishlisted =
          !product.isWishlisted;
        }

        return product;

      }).toList();

      emit(
        state.copyWith(
          products: updatedProducts,
        ),
      );
    });
  }

  Future<void> _onLoadUser(
      LoadUserEvent event,
      Emitter<HomeState> emit,
      ) async {

    try {

      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final name = await repository.getUserName(user.uid);

        emit(state.copyWith(userName: name));
      }

    } catch (e) {

      print(e);

      emit(
        state.copyWith(
          userName: 'Guest',
        ),
      );
    }
  }
}