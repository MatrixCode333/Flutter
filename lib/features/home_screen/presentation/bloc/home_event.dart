abstract class HomeEvent {}

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