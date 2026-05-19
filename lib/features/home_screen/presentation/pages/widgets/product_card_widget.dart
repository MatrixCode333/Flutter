import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/widgets/custom_icon_widget.dart';
import '../../../../../core/widgets/widgets/custom_image_widget.dart';


class ProductCardData {
  final String id;
  final String name;
  final double salePrice;
  final double originalPrice;
  final int discountPercent;
  final String imageUrl;
  final String semanticLabel;
  final String category;
  final double rating;
  bool isWishlisted;

  ProductCardData({
    required this.id,
    required this.name,
    required this.salePrice,
    required this.originalPrice,
    required this.discountPercent,
    required this.imageUrl,
    required this.semanticLabel,
    required this.category,
    required this.rating,
    this.isWishlisted = false,
  });

  factory ProductCardData.fromMap(Map<String, dynamic> map) {
    return ProductCardData(
      id: map['id'] as String,
      name: map['name'] as String,
      salePrice: (map['salePrice'] as num).toDouble(),
      originalPrice: (map['originalPrice'] as num).toDouble(),
      discountPercent: map['discountPercent'] as int,
      imageUrl: map['imageUrl'] as String,
      semanticLabel: map['semanticLabel'] as String,
      category: map['category'] as String,
      rating: (map['rating'] as num).toDouble(),
      isWishlisted: map['isWishlisted'] as bool? ?? false,
    );
  }
}

class ProductCardWidget extends StatefulWidget {
  final ProductCardData product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  const ProductCardWidget({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCart,
  });

  @override
  State<ProductCardWidget> createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<ProductCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.96,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnimation = _scaleController;
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) => _scaleController.reverse(),
        onTapUp: (_) {
          _scaleController.forward();
          widget.onTap?.call();
        },
        onTapCancel: () => _scaleController.forward(),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(18),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image zone with discount badge
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: CustomImageWidget(
                        imageUrl: widget.product.imageUrl,
                        fit: BoxFit.cover,
                        semanticLabel: widget.product.semanticLabel,
                      ),
                    ),
                  ),
                  // Discount badge
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.discount,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        '-${widget.product.discountPercent}%',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // Wishlist button
                  Positioned(
                    top: 10,
                    left: 10,
                    child: GestureDetector(
                      onTap: () => setState(
                        () => widget.product.isWishlisted =
                            !widget.product.isWishlisted,
                      ),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(230),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(26),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: widget.product.isWishlisted
                                ? 'favorite'
                                : 'favorite_border',
                            color: widget.product.isWishlisted
                                ? AppTheme.error
                                : const Color(0xFF9E9E9E),
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Product info
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A1A),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$${widget.product.salePrice.toStringAsFixed(0)}',
                              style: GoogleFonts.outfit(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.primary,
                              ),
                            ),
                            Text(
                              '\$${widget.product.originalPrice.toStringAsFixed(0)}',
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF9E9E9E),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: widget.onAddToCart,
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: CustomIconWidget(
                                iconName: 'shopping_cart',
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
