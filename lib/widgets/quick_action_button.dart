import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final VoidCallback? onTapDown;
  final VoidCallback? onTapUp;
  final VoidCallback? onTapCancel;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;

  const QuickActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    // Fallback to default theme colors if not provided
    final bg = backgroundColor ?? AppTheme.actionYellow;
    final icoColor = iconColor ?? AppTheme.textDark;
    final txtColor = textColor ?? AppTheme.textLight;

    return GestureDetector(
      onTap: onTap,
      onTapDown: onTapDown != null ? (_) => onTapDown!() : null,
      onTapUp: onTapUp != null ? (_) => onTapUp!() : null,
      onTapCancel: onTapCancel,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circular container with the icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: icoColor,
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          // Label below the button
          Text(
            label,
            style: AppTheme.bodySmall.copyWith(
              color: txtColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
