import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../widgets/custom_icon_widget.dart';

// TODO: Replace with Riverpod/Bloc for production navigation state
class AppNavigation extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isVisible;

  const AppNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.isVisible = true,
  });

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, 1.5)).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );
  }

  @override
  void didUpdateWidget(AppNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _slideController.reverse();
      } else {
        _slideController.forward();
      }
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
        child: Container(
          height: 68,
          decoration: BoxDecoration(
            color: AppTheme.secondary,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(51),
                blurRadius: 24,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                iconName: 'home',
                iconNameOutlined: 'home_outlined',
                label: 'Home',
                index: 0,
                currentIndex: widget.currentIndex,
                onTap: widget.onTap,
              ),
              _NavItem(
                iconName: 'category',
                iconNameOutlined: 'category_outlined',
                label: 'Categories',
                index: 1,
                currentIndex: widget.currentIndex,
                onTap: widget.onTap,
              ),
              _NavItem(
                iconName: 'favorite',
                iconNameOutlined: 'favorite_border',
                label: 'Wishlist',
                index: 2,
                currentIndex: widget.currentIndex,
                onTap: widget.onTap,
              ),
              _NavItem(
                iconName: 'shopping_bag',
                iconNameOutlined: 'shopping_bag_outlined',
                label: 'Orders',
                index: 3,
                currentIndex: widget.currentIndex,
                onTap: widget.onTap,
                badgeCount: 2,
              ),
              _NavItem(
                iconName: 'person',
                iconNameOutlined: 'person_outlined',
                label: 'Profile',
                index: 4,
                currentIndex: widget.currentIndex,
                onTap: widget.onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String iconName;
  final String iconNameOutlined;
  final String label;
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int? badgeCount;

  const _NavItem({
    required this.iconName,
    required this.iconNameOutlined,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primary.withAlpha(38) : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                CustomIconWidget(
                  iconName: isActive ? iconName : iconNameOutlined,
                  color: isActive ? AppTheme.primary : Colors.white54,
                  size: 22,
                ),
                if (badgeCount != null && badgeCount! > 0)
                  Positioned(
                    top: -4,
                    right: -6,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: AppTheme.error,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$badgeCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            if (isActive) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
