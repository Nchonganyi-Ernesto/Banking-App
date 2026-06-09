import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../models/user_model.dart';
import '../../../providers/user_provider.dart';

// Top-up screen with Mobile Money and Orange Money options
class TopUpScreen extends ConsumerStatefulWidget {
  const TopUpScreen({super.key});

  @override
  ConsumerState<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends ConsumerState<TopUpScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  
  // Controllers for Mobile Money
  final _mobileAmountController = TextEditingController();
  final _mobilePhoneController = TextEditingController();
  
  // Controllers for Orange Money
  final _orangeAmountController = TextEditingController();
  final _orangePhoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _mobileAmountController.dispose();
    _mobilePhoneController.dispose();
    _orangeAmountController.dispose();
    _orangePhoneController.dispose();
    super.dispose();
  }

  void _handleTopUp(String provider) {
    final amountController = provider == 'Mobile Money'
        ? _mobileAmountController
        : _orangeAmountController;
    final phoneController = provider == 'Mobile Money'
        ? _mobilePhoneController
        : _orangePhoneController;

    if (amountController.text.isEmpty) {
      _showError('Please enter an amount');
      return;
    }

    if (phoneController.text.isEmpty) {
      _showError('Please enter your phone number');
      return;
    }

    final amount = double.tryParse(amountController.text) ?? 0;
    
    if (amount <= 0) {
      _showError('Please enter a valid amount');
      return;
    }

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Top-up request of ${amount.toStringAsFixed(2)}FCFA via $provider initiated!\nCheck your phone to approve.',
        ),
        backgroundColor: AppTheme.receivedGreen,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    // Clear fields
    amountController.clear();
    phoneController.clear();

    // Navigate back after delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Navigator.pop(context);
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.sentRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
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
        title: const Text(
          'Top Up Balance',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF0F2B2B),
              borderRadius: BorderRadius.circular(14),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppTheme.actionYellow,
                borderRadius: BorderRadius.circular(14),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: AppTheme.textDark,
              unselectedLabelColor: Colors.white.withValues(alpha: 0.6),
              labelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(
                  icon: Icon(Icons.phone_android_rounded, size: 20),
                  text: 'Mobile Money',
                  height: 50,
                ),
                Tab(
                  icon: Icon(Icons.circle, size: 20),
                  text: 'Orange Money',
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // Balance Card - Delay: 0ms
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _StaggeredAnimation(
                delay: 0,
                child: _AnimatedBalanceCard(user: user),
              ),
            ),

            const SizedBox(height: 20),

            // TabBarView with scrollable content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Mobile Money Tab
                  _buildTopUpForm(
                    provider: 'Mobile Money',
                    icon: Icons.phone_android_rounded,
                    color: const Color(0xFF1E88E5),
                    amountController: _mobileAmountController,
                    phoneController: _mobilePhoneController,
                  ),
                  
                  // Orange Money Tab
                  _buildTopUpForm(
                    provider: 'Orange Money',
                    icon: Icons.circle,
                    color: const Color(0xFFFF6F00),
                    amountController: _orangeAmountController,
                    phoneController: _orangePhoneController,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopUpForm({
    required String provider,
    required IconData icon,
    required Color color,
    required TextEditingController amountController,
    required TextEditingController phoneController,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Provider Info Card - Delay: 0ms
          _StaggeredAnimation(
            delay: 0,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: color.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          provider,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Instant top-up via $provider',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Phone Number Field - Delay: 150ms
          _StaggeredAnimation(
            delay: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionLabel('Your $provider Number'),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: phoneController,
                  hint: '+237 6XX XXX XXX',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Amount Field - Delay: 300ms
          _StaggeredAnimation(
            delay: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionLabel('Amount to Top Up'),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: amountController,
                  hint: '0.00',
                  icon: Icons.currency_franc_rounded,
                  keyboardType: TextInputType.number,
                  suffix: 'FCFA',
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Quick Amount Buttons - Delay: 450ms
          _StaggeredAnimation(
            delay: 450,
            child: _buildQuickAmounts(amountController),
          ),

          const SizedBox(height: 24),

          // Info Box - Delay: 600ms
          _StaggeredAnimation(
            delay: 600,
            child: _AnimatedInfoBox(),
          ),

          const SizedBox(height: 24),

          // Top Up Button - Delay: 750ms
          _StaggeredAnimation(
            delay: 750,
            child: _AnimatedButton(
              onPressed: () => _handleTopUp(provider),
              icon: Icons.add_card_rounded,
              label: 'Top Up with $provider',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAmounts(TextEditingController controller) {
    final amounts = [500, 1000, 2000, 5000];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Select',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: amounts.map((amount) {
            return GestureDetector(
              onTap: () {
                controller.text = amount.toString();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F2B2B),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppTheme.mediumGreen.withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  '${amount}FCFA',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? suffix,
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
          suffixText: suffix,
          suffixStyle: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.7),
            fontWeight: FontWeight.w600,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
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

// Animated Balance Card with scale and fade effect
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
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppTheme.cardGreen,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              'Current Balance',
              style: AppTheme.bodySmall.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${widget.user.balance.toStringAsFixed(2)}FCFA',
              style: const TextStyle(
                fontSize: 28,
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

// Animated Info Box with pulse effect
class _AnimatedInfoBox extends StatefulWidget {
  @override
  State<_AnimatedInfoBox> createState() => _AnimatedInfoBoxState();
}

class _AnimatedInfoBoxState extends State<_AnimatedInfoBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _pulseAnimation,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.mediumGreen.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppTheme.actionYellow.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: AppTheme.actionYellow,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'You will receive a prompt on your phone to approve this transaction.',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Animated Button with press effect
class _AnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;

  const _AnimatedButton({
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton> {
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
          height: 52,
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
                size: 20,
                color: AppTheme.textDark,
              ),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 15,
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
