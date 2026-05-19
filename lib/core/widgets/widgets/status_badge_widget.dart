import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum BadgeStatus { active, pending, shipped, delivered, cancelled, sale }

class StatusBadgeWidget extends StatelessWidget {
  final BadgeStatus status;
  final String? customLabel;

  const StatusBadgeWidget({super.key, required this.status, this.customLabel});

  @override
  Widget build(BuildContext context) {
    final config = _getConfig();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config.bgColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        customLabel ?? config.label,
        style: GoogleFonts.outfit(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: config.textColor,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  _BadgeConfig _getConfig() {
    switch (status) {
      case BadgeStatus.active:
        return _BadgeConfig(
          label: 'Active',
          bgColor: const Color(0xFFE8F5E9),
          textColor: const Color(0xFF2D7A4F),
        );
      case BadgeStatus.pending:
        return _BadgeConfig(
          label: 'Pending',
          bgColor: const Color(0xFFFFF8E1),
          textColor: const Color(0xFFB45309),
        );
      case BadgeStatus.shipped:
        return _BadgeConfig(
          label: 'Shipped',
          bgColor: const Color(0xFFE3F2FD),
          textColor: const Color(0xFF1565C0),
        );
      case BadgeStatus.delivered:
        return _BadgeConfig(
          label: 'Delivered',
          bgColor: const Color(0xFFE8F5E9),
          textColor: const Color(0xFF2D7A4F),
        );
      case BadgeStatus.cancelled:
        return _BadgeConfig(
          label: 'Cancelled',
          bgColor: const Color(0xFFFFEBEE),
          textColor: const Color(0xFFB91C1C),
        );
      case BadgeStatus.sale:
        return _BadgeConfig(
          label: 'Sale',
          bgColor: const Color(0xFFB91C1C),
          textColor: Colors.white,
        );
    }
  }
}

class _BadgeConfig {
  final String label;
  final Color bgColor;
  final Color textColor;
  _BadgeConfig({
    required this.label,
    required this.bgColor,
    required this.textColor,
  });
}
