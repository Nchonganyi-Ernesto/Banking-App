import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';
import '../models/user_model.dart';
import 'quick_action_button.dart';
import '../features/transfer/screens/transfer_screen.dart';
import '../features/transfer/screens/topup_screen.dart';
import '../features/transfer/screens/withdraw_screen.dart';

class BalanceCard extends StatefulWidget {
  final UserModel user;

  const BalanceCard({super.key, required this.user});

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  // Track which button is currently being pressed
  String? _activeButton;

  @override
  Widget build(BuildContext context) {
    // Split the balance to format the cents in a smaller font size
    final balanceString = widget.user.balance.toStringAsFixed(2);
    final parts = balanceString.split('.');
    final integerPart = parts[0];
    final decimalPart = parts.length > 1 ? parts[1] : '00';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
      decoration: BoxDecoration(
        color: AppTheme.cardGreen,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Row 1: Balance Details + Sparkline Chart ───────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column: Balance Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Balance',
                      style: AppTheme.bodySmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Formatted balance: cents are smaller
                    Text(
                      '${integerPart}FCFA',
                      style: GoogleFonts.inter(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.actionYellow,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${widget.user.available.toStringAsFixed(2)}FCFA Available',
                      style: AppTheme.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Right Column: Sparkline & Due
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Mini Line Chart
                  SizedBox(
                    width: 95,
                    height: 45,
                    child: _buildSparkline(widget.user.sparklineData),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Row 2: Quick Action Buttons (Embedded inside Card) ────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              QuickActionButton(
                icon: Icons.upload_rounded,
                label: 'Send',
                backgroundColor: _activeButton == 'send' 
                    ? AppTheme.actionYellow 
                    : AppTheme.mediumGreen,
                iconColor: _activeButton == 'send' 
                    ? AppTheme.textDark 
                    : Colors.white,
                textColor: Colors.white.withValues(alpha: 0.9),
                onTapDown: () => setState(() => _activeButton = 'send'),
                onTapUp: () => setState(() => _activeButton = null),
                onTapCancel: () => setState(() => _activeButton = null),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TransferScreen(mode: TransferMode.send),
                    ),
                  );
                },
              ),
              QuickActionButton(
                icon: Icons.account_balance_wallet_rounded,
                label: 'Top Up',
                backgroundColor: _activeButton == 'topup' 
                    ? AppTheme.actionYellow 
                    : AppTheme.mediumGreen,
                iconColor: _activeButton == 'topup' 
                    ? AppTheme.textDark 
                    : Colors.white,
                textColor: Colors.white.withValues(alpha: 0.9),
                onTapDown: () => setState(() => _activeButton = 'topup'),
                onTapUp: () => setState(() => _activeButton = null),
                onTapCancel: () => setState(() => _activeButton = null),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TopUpScreen(),
                    ),
                  );
                },
              ),
              QuickActionButton(
                icon: Icons.download_rounded,
                label: 'Withdraw',
                backgroundColor: AppTheme.mediumGreen,
                iconColor: Colors.white,
                textColor: Colors.white.withValues(alpha: 0.9),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const WithdrawScreen(),
                  ),
                ),
              ),
              QuickActionButton(
                icon: Icons.quiz_rounded,
                label: 'Play Quiz',
                backgroundColor: AppTheme.mediumGreen,
                iconColor: Colors.white,
                textColor: Colors.white.withValues(alpha: 0.9),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('🎯 Quiz coming soon! Test your financial knowledge and win cash back.'),
                      backgroundColor: AppTheme.mediumGreen,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Sparkline Chart Builder ───────────────────────────────────────────────
  Widget _buildSparkline(List<double> data) {
    final spots = data
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: const LineTouchData(enabled: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppTheme.accentGreen,
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppTheme.accentGreen.withValues(alpha: 0.35),
                  AppTheme.accentGreen.withValues(alpha: 0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
