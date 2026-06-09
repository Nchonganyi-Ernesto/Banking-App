import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../models/user_model.dart';
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
  final _recipientNameController = TextEditingController();
  final _recipientPhoneController = TextEditingController();
  final _purposeController = TextEditingController();

  // Called when the form is disposed (screen closed) to free memory
  @override
  void dispose() {
    _amountController.dispose();
    _recipientNameController.dispose();
    _recipientPhoneController.dispose();
    _purposeController.dispose();
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

    // Validate recipient account field for send mode
    if (widget.mode == TransferMode.send) {
      if (_recipientPhoneController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please enter recipient account number'),
            backgroundColor: AppTheme.sentRed,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        return;
      }
    }

    final amount = double.tryParse(_amountController.text) ?? 0;

    // Show a success snackbar — in a real app this would call an API
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$_title of ${amount.toStringAsFixed(2)}FCFA successful!'),
        backgroundColor: AppTheme.receivedGreen,
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
        backgroundColor: AppTheme.cardGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Current Balance Display - Delay: 0ms ─────────────────────────────────
              _StaggeredAnimation(
                delay: 0,
                child: _AnimatedBalanceCard(user: user),
              ),
              const SizedBox(height: 32),

              // ── Recipient Fields (only shown for 'send' mode) ───────────
              if (widget.mode == TransferMode.send) ...[
                _StaggeredAnimation(
                  delay: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionLabel('Recipient Account'),
                      const SizedBox(height: 10),
                      _buildTextField(
                        controller: _recipientPhoneController,
                        hint: 'Phone number or Account number',
                        icon: Icons.account_balance_outlined,
                        keyboardType: TextInputType.phone,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // ── Amount Input - Delay: 300ms (or 150ms if no recipient field) ────────────────────────────────────────────
              _StaggeredAnimation(
                delay: widget.mode == TransferMode.send ? 300 : 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionLabel('Enter Amount'),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _amountController,
                      hint: '0.00 FCFA',
                      icon: Icons.currency_franc_rounded,
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Additional Recipient Details (only shown for 'send' mode) ───────────
              if (widget.mode == TransferMode.send) ...[
                _StaggeredAnimation(
                  delay: 450,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionLabel('Recipient Name (Optional)'),
                      const SizedBox(height: 10),
                      _buildTextField(
                        controller: _recipientNameController,
                        hint: 'Full name',
                        icon: Icons.person_outline_rounded,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                _StaggeredAnimation(
                  delay: 600,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionLabel('Purpose (Optional)'),
                      const SizedBox(height: 10),
                      _buildTextField(
                        controller: _purposeController,
                        hint: 'e.g., Rent, Utility, Gift',
                        icon: Icons.note_outlined,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // ── Action Button - Delay based on mode ────────────────────────────────────────────
              _StaggeredAnimation(
                delay: widget.mode == TransferMode.send ? 750 : 300,
                child: _AnimatedActionButton(
                  onPressed: _handleSubmit,
                  icon: _icon,
                  label: _buttonLabel,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Section label with better styling
  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        letterSpacing: 0.3,
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
        color: const Color(0xFF0F2B2B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.mediumGreen.withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.4),
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            icon,
            color: AppTheme.actionYellow,
            size: 22,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        ),
      ),
    );
  }
}


// ── Animated Widgets ───────────────────────────────────────────────────────

// Staggered Animation Widget - Creates slide-up effect with delay
class _StaggeredAnimation extends StatefulWidget {
  final Widget child;
  final int delay; // delay in milliseconds

  const _StaggeredAnimation({
    required this.child,
    required this.delay,
  });

  @override
  State<_StaggeredAnimation> createState() => _StaggeredAnimationState();
}

class _StaggeredAnimationState extends State<_StaggeredAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    // Start animation after delay
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}

// Animated Balance Card for transfer screen
class _AnimatedBalanceCard extends StatefulWidget {
  final UserModel user;

  const _AnimatedBalanceCard({required this.user});

  @override
  State<_AnimatedBalanceCard> createState() => _AnimatedBalanceCardState();
}

class _AnimatedBalanceCardState extends State<_AnimatedBalanceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.cardGreen,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              'Available Balance',
              style: AppTheme.bodySmall.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.user.balance.toStringAsFixed(2)}FCFA',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: Color(0xFFD8FA3C),
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Animated Action Button with press effect
class _AnimatedActionButton extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;

  const _AnimatedActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  @override
  State<_AnimatedActionButton> createState() => _AnimatedActionButtonState();
}

class _AnimatedActionButtonState extends State<_AnimatedActionButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: AppTheme.actionYellow,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.actionYellow.withValues(alpha: 0.4),
                blurRadius: _isPressed ? 8 : 12,
                offset: Offset(0, _isPressed ? 2 : 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                size: 24,
                color: AppTheme.textDark,
              ),
              const SizedBox(width: 12),
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
