
import '../../data/datasource/product_data.dart';
import '../pages/widgets/product_card_widget.dart';

class HomeState {

  final int currentNavIndex;

  final String selectedCategory;

  final List<ProductCardData> products;

  final String userName;

  HomeState({
    required this.currentNavIndex,
    required this.selectedCategory,
    required this.products,
    required this.userName,
  });

  factory HomeState.initial() {
    return HomeState(
      currentNavIndex: 0,
      selectedCategory: 'All',
      products: productMaps
          .map(ProductCardData.fromMap)
          .toList(),
      userName: '',
    );
  }

  HomeState copyWith({
    int? currentNavIndex,
    String? selectedCategory,
    List<ProductCardData>? products,
    String? userName,
  }) {
    return HomeState(
      currentNavIndex:
      currentNavIndex ?? this.currentNavIndex,

      selectedCategory:
      selectedCategory ?? this.selectedCategory,

      products: products ?? this.products,

      userName: userName ?? this.userName,
    );
  }
}