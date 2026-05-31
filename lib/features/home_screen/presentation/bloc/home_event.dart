import 'package:image_picker/image_picker.dart';

abstract class HomeEvent {}

// ── Existing Events ───────────────────────────────────────────────────────────

class LoadUserEvent extends HomeEvent {}

class ChangeCategoryEvent extends HomeEvent {
  final String category;
  ChangeCategoryEvent(this.category);
}

class ChangeBottomNavEvent extends HomeEvent {
  final int index;
  ChangeBottomNavEvent(this.index);
}

class ToggleWishlistEvent extends HomeEvent {
  final String productId;
  ToggleWishlistEvent(this.productId);
}

// ── Wedding Invitation Events ─────────────────────────────────────────────────

/// Triggered when the user taps "Proceed" to save the invitation.
class SaveInvitationEvent extends HomeEvent {
  final String brideName;
  final String groomName;
  final String venue;
  final String address;
  final String mapUrl;
  final DateTime weddingDate;
  final XFile bannerXFile;
  final XFile brideXFile;
  final XFile groomXFile;
  final List<XFile> galleryXFiles;

  SaveInvitationEvent({
    required this.brideName,
    required this.groomName,
    required this.venue,
    required this.address,
    required this.mapUrl,
    required this.weddingDate,
    required this.bannerXFile,
    required this.brideXFile,
    required this.groomXFile,
    required this.galleryXFiles,
  });
}

/// Resets invitation status flags (error / saved) back to null.
/// Call this when navigating away or re-entering the screen.
class ResetInvitationStatusEvent extends HomeEvent {}