import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/repositories/home_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc(this.repository) : super(HomeState.initial()) {
    // ── Existing Handlers ───────────────────────────────────────────────────
    on<LoadUserEvent>(_onLoadUser);

    on<ChangeCategoryEvent>((event, emit) {
      emit(state.copyWith(selectedCategory: event.category));
    });

    on<ChangeBottomNavEvent>((event, emit) {
      emit(state.copyWith(currentNavIndex: event.index));
    });

    on<ToggleWishlistEvent>((event, emit) {
      final updatedProducts = state.products.map((product) {
        if (product.id == event.productId) {
          product.isWishlisted = !product.isWishlisted;
        }
        return product;
      }).toList();

      emit(state.copyWith(products: updatedProducts));
    });

    // ── Wedding Invitation Handlers ─────────────────────────────────────────
    on<SaveInvitationEvent>(_onSaveInvitation);

    on<ResetInvitationStatusEvent>((event, emit) {
      emit(state.copyWith(
        isInvitationLoading: false,
        savedInvitationId: null,
        invitationLink: null, // Clears link state on screen reset/init
        invitationError: null,
      ));
    });
  }

  // ── _onLoadUser ─────────────────────────────────────────────────────────────
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
      debugPrint('LoadUserEvent error: $e');
      emit(state.copyWith(userName: 'Guest'));
    }
  }

  // ── _onSaveInvitation ───────────────────────────────────────────────────────
  Future<void> _onSaveInvitation(
      SaveInvitationEvent event,
      Emitter<HomeState> emit,
      ) async {
    emit(state.copyWith(
      isInvitationLoading: true,
      savedInvitationId: null,
      invitationLink: null, // Reset link while updating database
      invitationError: null,
    ));

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final bannerBase64  = await _xFileToBase64(event.bannerXFile);
      final brideBase64   = await _xFileToBase64(event.brideXFile);
      final groomBase64   = await _xFileToBase64(event.groomXFile);
      final galleryBase64 = await _galleryToBase64(event.galleryXFiles);

      final invitationRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(user.uid)
          .child('invitation');

      final invitationLink =
          "https://codetrax-8fd48.web.app/#/invitation/${user.uid}";

      await invitationRef.set({
        'bride_name'     : event.brideName,
        'groom_name'     : event.groomName,
        'venue'          : event.venue,
        'address'        : event.address,
        'map_url'        : event.mapUrl,
        'invitationLink' : invitationLink,
        'date'           : event.weddingDate.toString(),
        'banner_image'   : bannerBase64,
        'bride_image'    : brideBase64,
        'groom_image'    : groomBase64,
        'gallery_images' : galleryBase64,
      });

      debugPrint('Invitation saved/updated at users/${user.uid}/invitation');

      // Emitting with the calculated link
      emit(state.copyWith(
        isInvitationLoading: false,
        savedInvitationId: 'invitation',
        invitationLink: invitationLink, // Passed successfully to UI layer
        invitationError: null,
      ));
    } catch (e) {
      debugPrint('SaveInvitationEvent error: $e');
      emit(state.copyWith(
        isInvitationLoading: false,
        invitationError: e.toString(),
      ));
    }
  }

  // ── Private helpers ─────────────────────────────────────────────────────────
  Future<String> _xFileToBase64(XFile file) async {
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  Future<List<String>> _galleryToBase64(List<XFile> files) async {
    final List<String> result = [];
    for (final file in files) {
      result.add(await _xFileToBase64(file));
    }
    return result;
  }
}