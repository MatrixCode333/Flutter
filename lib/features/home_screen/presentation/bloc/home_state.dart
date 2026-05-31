import '../../data/datasource/product_data.dart';
import '../pages/widgets/product_card_widget.dart';

class HomeState {
  // ── Existing Fields ───────────────────────────────────────────────────────

  final int currentNavIndex;
  final String selectedCategory;
  final List<ProductCardData> products;
  final String userName;

  // ── Wedding Invitation Fields ─────────────────────────────────────────────

  /// True while the invitation is being saved to Firebase.
  final bool isInvitationLoading;

  /// Non-null when the invitation was saved successfully.
  /// Holds the Firebase push key of the saved invitation.
  final String? savedInvitationId;

  /// Non-null when saving failed. Holds the error message.
  final String? invitationError;

  // ── Constructor ───────────────────────────────────────────────────────────

  HomeState({
    required this.currentNavIndex,
    required this.selectedCategory,
    required this.products,
    required this.userName,
    this.isInvitationLoading = false,
    this.savedInvitationId,
    this.invitationError,
  });

  // ── initial ───────────────────────────────────────────────────────────────

  factory HomeState.initial() {
    return HomeState(
      currentNavIndex: 0,
      selectedCategory: 'All',
      products: productMaps.map(ProductCardData.fromMap).toList(),
      userName: '',
      isInvitationLoading: false,
      savedInvitationId: null,
      invitationError: null,
    );
  }

  // ── copyWith ──────────────────────────────────────────────────────────────

  HomeState copyWith({
    int? currentNavIndex,
    String? selectedCategory,
    List<ProductCardData>? products,
    String? userName,
    bool? isInvitationLoading,
    // Use a sentinel to distinguish "set to null" vs "keep existing"
    Object? savedInvitationId = _keep,
    Object? invitationError = _keep,
  }) {
    return HomeState(
      currentNavIndex: currentNavIndex ?? this.currentNavIndex,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      products: products ?? this.products,
      userName: userName ?? this.userName,
      isInvitationLoading:
      isInvitationLoading ?? this.isInvitationLoading,
      savedInvitationId: savedInvitationId == _keep
          ? this.savedInvitationId
          : savedInvitationId as String?,
      invitationError: invitationError == _keep
          ? this.invitationError
          : invitationError as String?,
    );
  }
}

// Sentinel object so copyWith can explicitly clear nullable fields.
const Object _keep = Object();