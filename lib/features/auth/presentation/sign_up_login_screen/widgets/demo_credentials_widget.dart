import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/widgets/custom_icon_widget.dart';

class DemoCredentialsWidget extends StatelessWidget {
  final void Function(String email, String password) onAutofill;

  const DemoCredentialsWidget({super.key, required this.onAutofill});

  static const String _demoEmail = 'maya.chen@shopdash.app';
  static const String _demoPassword = 'ShopDash2026';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primary.withAlpha(15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primary.withAlpha(51), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'info',
                color: AppTheme.primary,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                'Demo Credentials',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _CredentialRow(
            label: 'Email',
            value: _demoEmail,
            onCopy: () {
              Clipboard.setData(const ClipboardData(text: _demoEmail));
              //Fluttertoast.showToast(msg: 'Email copied');
            },
          ),
          const SizedBox(height: 8),
          _CredentialRow(
            label: 'Password',
            value: _demoPassword,
            onCopy: () {
              Clipboard.setData(const ClipboardData(text: _demoPassword));
              //Fluttertoast.showToast(msg: 'Password copied');
            },
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => onAutofill(_demoEmail, _demoPassword),
              style: TextButton.styleFrom(
                backgroundColor: AppTheme.primary.withAlpha(26),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              child: Text(
                'Use Demo Account',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CredentialRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onCopy;

  const _CredentialRow({
    required this.label,
    required this.value,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 64,
          child: Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF9E9E9E),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A1A),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        GestureDetector(
          onTap: onCopy,
          child: CustomIconWidget(
            iconName: 'copy',
            color: AppTheme.primary,
            size: 16,
          ),
        ),
      ],
    );
  }
}
