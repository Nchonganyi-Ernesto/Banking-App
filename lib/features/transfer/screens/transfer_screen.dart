import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../providers/user_provider.dart';

// TransferMode is an enum — a fixed set of named values.
// Enums are safer than using raw strings like 'send', 'topUp' because the
// Dart compiler will catch typos (e.g. 'sned' would be a compile error with an enum).
enum TransferMode { send, withdraw, topUp }

class TransferScreen extends ConsumerStatefulWidget {
  final TransferMode mode;

  const TransferScreen({super.key, required this.mode});

  @override
  ConsumerState<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends ConsumerState<TransferScreen> {
  // TextEditingController lets us read what the user typed in the amount field
  final _amountController = TextEditingController();
  final _recipientController = TextEditingController();

  // Called when the form is disposed (screen closed) to free memory
  @override
  void dispose() {
    _amountController.dispose();
    _recipientController.dispose();
    super.dispose();
  }

  // Returns the correct title based on which mode was passed in
  String get _title {
    switch (widget.mode) {
      case TransferMode.send:
        return 'Send Money';
      case TransferMode.withdraw:
        return 'Withdraw';
      case TransferMode.topUp:
        return 'Top Up';
    }
  }

  // Returns the correct action button label
  String get _buttonLabel {
    switch (widget.mode) {
      case TransferMode.send:
        return 'Send Now';
      case TransferMode.withdraw:
        return 'Withdraw Now';
      case TransferMode.topUp:
        return 'Top Up Now';
    }
  }

  // Returns the correct icon for the mode
  IconData get _icon {
    switch (widget.mode) {
      case TransferMode.send:
        return Icons.send_rounded;
      case TransferMode.withdraw:
        return Icons.arrow_downward_rounded;
      case TransferMode.topUp:
        return Icons.add_rounded;
    }
  }

  void _handleSubmit() {
    // Basic validation — don't proceed if the field is empty
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter an amount'),
          backgroundColor: AppTheme.sentRed,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text) ?? 0;

    // Show a success snackbar — in a real app this would call an API
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$_title of \$${amount.toStringAsFixed(2)} successful!'),
        backgroundColor: AppTheme.accentGreen,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    // Go back to the dashboard after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

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
          _title,
          style: AppTheme.headingMedium.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // ── Current Balance Display ─────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.cardGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      'Available Balance',
                      style: AppTheme.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${user.balance.toStringAsFixed(2)}',
                      style: AppTheme.balanceAmount.copyWith(fontSize: 26),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ── Amount Input ────────────────────────────────────────────
              Text('Enter Amount', style: AppTheme.bodyMedium),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _amountController,
                hint: '\$0.00',
                icon: Icons.attach_money_rounded,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              // ── Recipient / Note (only shown for 'send' mode) ───────────
              if (widget.mode == TransferMode.send) ...[
                Text('Recipient', style: AppTheme.bodyMedium),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: _recipientController,
                  hint: 'Name or account number',
                  icon: Icons.person_outline_rounded,
                ),
                const SizedBox(height: 20),
              ],

              const SizedBox(height: 16),

              // ── Action Button ────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _handleSubmit,
                  icon: Icon(_icon, color: AppTheme.textDark),
                  label: Text(
                    _buttonLabel,
                    style: AppTheme.labelBold.copyWith(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.actionYellow,
                    foregroundColor: AppTheme.textDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: AppTheme.actionYellow.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable styled text field builder — keeps build() clean
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.textMuted.withValues(alpha: 0.2)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: AppTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTheme.bodySmall,
          prefixIcon: Icon(icon, color: AppTheme.textMuted),
          border: InputBorder.none, // Remove default Flutter underline
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}
