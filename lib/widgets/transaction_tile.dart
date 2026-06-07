import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/transaction_model.dart';

// TransactionTile displays ONE row in the transaction list.
// It receives a TransactionModel and renders it.
// By keeping this in its own file, the dashboard screen stays clean and readable.

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionTile({super.key, required this.transaction});

  // Maps the iconPath string from TransactionModel to a real Material Icon.
  // This keeps icon logic OUT of the model (models shouldn't know about Flutter).
  IconData _getIcon(String iconPath) {
    switch (iconPath) {
      case 'dribble':
        return Icons.sports_basketball;
      case 'apple':
        return Icons.apple;
      case 'amazon':
        return Icons.shopping_bag_outlined;
      case 'work':
        return Icons.work_outline;
      case 'movie':
        return Icons.movie_outlined;
      default:
        return Icons.monetization_on_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Decide color based on isReceived flag from the model
    final amountColor =
        transaction.isReceived ? AppTheme.receivedGreen : AppTheme.sentRed;
    final amountPrefix = transaction.isReceived ? '+' : '-';
    final statusLabel = transaction.isReceived ? 'Received' : 'Sent';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Left: Company Icon ──────────────────────────────────────────
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.iconBg,
              shape: BoxShape.circle, // Rounded circle for icon container
            ),
            child: Icon(
              _getIcon(transaction.iconPath),
              color: AppTheme.darkGreen,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),

          // ── Middle: Name + Date ─────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.name,
                  style: AppTheme.labelBold.copyWith(
                    color: AppTheme.textDark,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.date,
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),

          // ── Right: Amount + Status ──────────────────────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$amountPrefix\$${transaction.amount.toStringAsFixed(2)}',
                style: AppTheme.labelBold.copyWith(
                  color: AppTheme.textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              // Circular colored dot + Text status indicator
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: amountColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    statusLabel,
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textMuted,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
