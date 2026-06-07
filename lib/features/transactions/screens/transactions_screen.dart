import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../providers/transaction_provider.dart';
import '../../../widgets/transaction_tile.dart';

// TransactionsScreen shows ALL transactions (no .take(3) limit like the dashboard).
// It uses ConsumerWidget because it reads the transactionProvider.

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch() — same pattern as dashboard. Read the provider, get the list.
    final transactions = ref.watch(transactionProvider);

    return Scaffold(
      backgroundColor: AppTheme.pageBg,
      appBar: AppBar(
        backgroundColor: AppTheme.pageBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: AppTheme.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'All Transactions',
          style: AppTheme.headingMedium.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Month filter chips — cosmetic for now, can be made functional later
              _buildFilterChips(),
              const SizedBox(height: 20),

              // The full list of all transactions
              Expanded(
                // Expanded fills remaining vertical space so ListView scrolls properly
                child: ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    return TransactionTile(transaction: transactions[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Simple cosmetic filter row — month pills above the list
  Widget _buildFilterChips() {
    final months = ['All', 'Jun', 'May', 'Apr', 'Mar'];
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal, // Horizontal scroll
        itemCount: months.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = index == 0; // "All" selected by default
          return Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.actionYellow
                  : AppTheme.iconBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              months[index],
              style: AppTheme.bodySmall.copyWith(
                color: isSelected
                    ? AppTheme.textDark
                    : AppTheme.textMuted,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          );
        },
      ),
    );
  }
}
