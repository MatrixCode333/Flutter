import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/home_bloc.dart';

import './product_card_widget.dart';

class ProductGridWidget extends StatelessWidget {
  final List<ProductCardData> products;

  final String selectedCategory;

  final int crossAxisCount;

  const ProductGridWidget({
    super.key,
    required this.products,
    required this.selectedCategory,
    this.crossAxisCount = 2,
  });

  List<ProductCardData> _filteredProducts() {
    if (selectedCategory == 'All') {
      return products;
    }

    return products
        .where(
          (product) =>
      product.category == selectedCategory,
    )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _filteredProducts();

    if (filteredProducts.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),

          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 64,
                  color: Theme.of(context)
                      .colorScheme
                      .outline,
                ),

                const SizedBox(height: 12),

                Text(
                  'No products in this category',

                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .outline,

                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final product = filteredProducts[index];

          return _AnimatedProductCard(
            product: product,
            index: index,
          );
        },

        childCount: filteredProducts.length,
      ),

      gridDelegate:
      SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,

        crossAxisSpacing: 12,

        mainAxisSpacing: 12,

        childAspectRatio: 0.62,
      ),
    );
  }
}

class _AnimatedProductCard extends StatefulWidget {
  final ProductCardData product;

  final int index;

  const _AnimatedProductCard({
    required this.product,
    required this.index,
  });

  @override
  State<_AnimatedProductCard> createState() =>
      _AnimatedProductCardState();
}

class _AnimatedProductCardState
    extends State<_AnimatedProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _fadeAnimation;

  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    final delay =
    (widget.index * 60).clamp(0, 400);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 400,
      ),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    Future.delayed(
      Duration(milliseconds: delay),
          () {
        if (mounted) {
          _controller.forward();
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,

      child: SlideTransition(
        position: _slideAnimation,

        child: ProductCardWidget(
          product: widget.product,

          onTap: () {},

          onAddToCart: () {},

          // onWishlistTap: () {
          //   context.read<HomeBloc>().add(
          //     ToggleWishlistEvent(
          //       widget.product.id,
          //     ),
          //   );
          // },
        ),
      ),
    );
  }
}