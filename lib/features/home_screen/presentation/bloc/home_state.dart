import '../../data/datasource/product_data.dart';
import '../pages/widgets/product_card_widget.dart';

class HomeState {
  // ── Existing Fields ───────────────────────────────────────────────────────
  final int currentNavIndex;
  final String selectedCategory;
  final List<ProductCardData> products;
  final String userName;

  // ── Wedding Invitation Fields ─────────────────────────────────────────────
  final bool isInvitationLoading;
  final String? savedInvitationId;
  final String? invitationLink; // ← Kept here
  final String? invitationError;

  // ── Constructor ───────────────────────────────────────────────────────────
  HomeState({
    required this.currentNavIndex,
    required this.selectedCategory,
    required this.products,
    required this.userName,
    this.isInvitationLoading = false,
    this.savedInvitationId,
    this.invitationLink,
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
      invitationLink: null, // Explicitly initialized to null
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
    Object? savedInvitationId = _keep,
    Object? invitationLink = _keep,   // Added here
    Object? invitationError = _keep,
  }) {
    return HomeState(
      currentNavIndex: currentNavIndex ?? this.currentNavIndex,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      products: products ?? this.products,
      userName: userName ?? this.userName,
      isInvitationLoading: isInvitationLoading ?? this.isInvitationLoading,
      savedInvitationId: savedInvitationId == _keep
          ? this.savedInvitationId
          : savedInvitationId as String?,
      invitationLink: invitationLink == _keep
          ? this.invitationLink
          : invitationLink as String?, // Added assignment logic
      invitationError: invitationError == _keep
          ? this.invitationError
          : invitationError as String?,
    );
  }
}

// Sentinel object so copyWith can explicitly clear nullable fields.
const Object _keep = Object();