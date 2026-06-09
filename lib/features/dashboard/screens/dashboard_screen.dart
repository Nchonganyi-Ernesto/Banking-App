import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../providers/user_provider.dart';
import '../../../providers/transaction_provider.dart';
import '../../../widgets/balance_card.dart';
import '../../../widgets/transaction_tile.dart';
import '../../transactions/screens/transactions_screen.dart';
import '../../statistics/screens/statistics_screen.dart';

// We use ConsumerWidget instead of StatelessWidget.
// ConsumerWidget gives us access to 'ref' — the tool to read Riverpod providers.
// Rule of thumb: if a screen needs data from a provider, use ConsumerWidget.

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  // Tracks which bottom nav item is selected (0 = Home, 1 = Cards, 2 = +, 3 = Settings)
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // ref.watch() subscribes to the provider.
    final user = ref.watch(userProvider);
    final transactions = ref.watch(transactionProvider);

    return Scaffold(
      backgroundColor: AppTheme.pageBg,
      bottomNavigationBar: _buildBottomNav(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // ── 1. Profile + Greeting + Notification Header ──────────────────
              _buildHeader(user.name),
              const SizedBox(height: 28),

              // ── 2. "Your Balance" title + "View Statistics" button ────────
              _buildBalanceHeader(),
              const SizedBox(height: 20),

              // ── 3. Balance Card (Includes balance info and embedded actions)
              BalanceCard(user: user),
              const SizedBox(height: 28),

              // ── 4. Transactions Header ─────────────────────────────────────
              _buildTransactionsHeader(context),
              const SizedBox(height: 12),

              // ── 5. Transaction List (first 3 only) ─────────────────────────
              ...transactions
                  .take(3)
                  .map((tx) => TransactionTile(transaction: tx)),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header Builder (Profile + Greeting + Notification) ─────────────────────
  Widget _buildHeader(String name) {
    final firstName = name.split(' ').first;

    return Row(
      children: [
        // Profile Avatar
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppTheme.darkGreen,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.darkGreen.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'U',
              style: AppTheme.labelBold.copyWith(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Greeting text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Morning 👋',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                firstName,
                style: AppTheme.labelBold.copyWith(
                  color: AppTheme.actionYellow,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),

        // Notification Bell Icon with Red Badge
        Stack(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.darkGreen,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.darkGreen.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.notifications_outlined,
                color: Colors.white,
                size: 22,
              ),
            ),
            // Red notification badge dot
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.sentRed,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.darkGreen, width: 1.5),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Balance Header Builder ────────────────────────────────────────────────
  Widget _buildBalanceHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Your\nBalance',
          style: AppTheme.headingLarge.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 32,
            height: 1.1,
            letterSpacing: -0.5,
            color: AppTheme.actionYellow,
          ),
        ),
        // White pill-shaped "View Statistics" button
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const StatisticsScreen(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppTheme.textDark,
            elevation: 1,
            shadowColor: Colors.black.withValues(alpha: 0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'View Statistics',
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.textDark,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  // ── Transactions Header Builder ───────────────────────────────────────────
  Widget _buildTransactionsHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Transactions',
          style: AppTheme.headingMedium.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const TransactionsScreen()),
          ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'View all',
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.actionYellow,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  // ── Bottom Navigation Bar ─────────────────────────────────────────────────
  // Custom navigation bar to match target design: dark green container with rounded corners,
  // circular items, and active/inactive styling.
  Widget _buildBottomNav() {
    return Container(
      height: 85,
      padding: const EdgeInsets.only(bottom: 12, top: 12),
      decoration: BoxDecoration(
        color: AppTheme.darkGreen,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem(Icons.home_rounded, 0),
          _navItem(Icons.credit_card_rounded, 1),
          _navItem(Icons.insert_chart_rounded, 2),
          _navItem(Icons.settings_rounded, 3),
        ],
      ),
    );
  }

  // Builds a circular nav item
  Widget _navItem(IconData icon, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.actionYellow : AppTheme.mediumGreen,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 22,
          color: isSelected ? AppTheme.textDark : Colors.white.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
