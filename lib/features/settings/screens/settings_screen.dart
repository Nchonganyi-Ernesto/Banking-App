import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/user_provider.dart';
import 'change_password_screen.dart';
import 'edit_profile_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with TickerProviderStateMixin {
  bool _notificationsEnabled = true;
  bool _biometricsEnabled = false;
  bool _darkModeEnabled = true;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final authState = ref.watch(firebaseAuthStateProvider);
    final firebaseUser = authState.asData?.value;
    final userName = firebaseUser?.displayName ?? user.name;
    final userEmail = firebaseUser?.email ?? 'No email';

    return Scaffold(
      backgroundColor: AppTheme.pageBg,
      appBar: AppBar(
        backgroundColor: AppTheme.pageBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Profile Section ────────────────────────────────────────
              _StaggeredAnimation(
                delay: 0,
                child: _buildProfileCard(userName, userEmail),
              ),
              const SizedBox(height: 24),

              // ── Account Settings ───────────────────────────────────────
              _StaggeredAnimation(
                delay: 150,
                child: _buildSectionTitle('Account'),
              ),
              const SizedBox(height: 12),
              _StaggeredAnimation(
                delay: 200,
                child: _buildSettingsList([
                  _SettingItem(
                    icon: Icons.person_outline,
                    title: 'Edit Profile',
                    subtitle: 'Update your personal information',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                    ),
                  ),
                  _SettingItem(
                    icon: Icons.lock_outline,
                    title: 'Change Password',
                    subtitle: 'Update your password',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
                    ),
                  ),
                  _SettingItem(
                    icon: Icons.phone_outlined,
                    title: 'Phone Number',
                    subtitle: 'Update your phone number in profile',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 24),

              // ── Security Settings ──────────────────────────────────────
              _StaggeredAnimation(
                delay: 350,
                child: _buildSectionTitle('Security'),
              ),
              const SizedBox(height: 12),
              _StaggeredAnimation(
                delay: 400,
                child: _buildSettingsList([
                  _SettingItem(
                    icon: Icons.fingerprint,
                    title: 'Biometric Authentication',
                    subtitle: 'Use fingerprint or face ID',
                    trailing: Switch(
                      value: _biometricsEnabled,
                      onChanged: (value) {
                        setState(() => _biometricsEnabled = value);
                      },
                      activeColor: AppTheme.actionYellow,
                    ),
                  ),
                  _SettingItem(
                    icon: Icons.pin_outlined,
                    title: 'Change PIN',
                    subtitle: 'Update your transaction PIN',
                    onTap: () => _showComingSoon(context),
                  ),
                  _SettingItem(
                    icon: Icons.verified_user_outlined,
                    title: 'Two-Factor Authentication',
                    subtitle: 'Add extra security layer',
                    onTap: () => _showComingSoon(context),
                  ),
                ]),
              ),
              const SizedBox(height: 24),

              // ── Preferences ────────────────────────────────────────────
              _StaggeredAnimation(
                delay: 550,
                child: _buildSectionTitle('Preferences'),
              ),
              const SizedBox(height: 12),
              _StaggeredAnimation(
                delay: 600,
                child: _buildSettingsList([
                  _SettingItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    subtitle: 'Manage notification settings',
                    trailing: Switch(
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() => _notificationsEnabled = value);
                      },
                      activeColor: AppTheme.actionYellow,
                    ),
                  ),
                  _SettingItem(
                    icon: Icons.dark_mode_outlined,
                    title: 'Dark Mode',
                    subtitle: 'Toggle dark/light theme',
                    trailing: Switch(
                      value: _darkModeEnabled,
                      onChanged: (value) {
                        setState(() => _darkModeEnabled = value);
                      },
                      activeColor: AppTheme.actionYellow,
                    ),
                  ),
                  _SettingItem(
                    icon: Icons.language_outlined,
                    title: 'Language',
                    subtitle: 'English',
                    onTap: () => _showComingSoon(context),
                  ),
                ]),
              ),
              const SizedBox(height: 24),

              // ── Support & About ────────────────────────────────────────
              _StaggeredAnimation(
                delay: 750,
                child: _buildSectionTitle('Support & About'),
              ),
              const SizedBox(height: 12),
              _StaggeredAnimation(
                delay: 800,
                child: _buildSettingsList([
                  _SettingItem(
                    icon: Icons.help_outline,
                    title: 'Help Center',
                    subtitle: 'Get help and support',
                    onTap: () => _showComingSoon(context),
                  ),
                  _SettingItem(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    subtitle: 'Read our privacy policy',
                    onTap: () => _showComingSoon(context),
                  ),
                  _SettingItem(
                    icon: Icons.description_outlined,
                    title: 'Terms of Service',
                    subtitle: 'Read terms and conditions',
                    onTap: () => _showComingSoon(context),
                  ),
                  _SettingItem(
                    icon: Icons.info_outline,
                    title: 'About',
                    subtitle: 'Version 1.0.0',
                    onTap: () => _showAboutDialog(context),
                  ),
                ]),
              ),
              const SizedBox(height: 24),

              // ── Logout Button ──────────────────────────────────────────
              _StaggeredAnimation(
                delay: 950,
                child: _buildLogoutButton(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(String name, String email) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Row(
        children: [
          // Avatar
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppTheme.actionYellow,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : 'U',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.actionYellow,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Edit Button
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              );
            },
            icon: const Icon(
              Icons.edit_outlined,
              color: Colors.white,
              size: 20,
            ),
            style: IconButton.styleFrom(
              backgroundColor: AppTheme.mediumGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.white.withValues(alpha: 0.6),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildSettingsList(List<_SettingItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F2B2B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.mediumGreen.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;

          return Column(
            children: [
              _buildSettingItem(item),
              if (!isLast)
                Divider(
                  height: 1,
                  thickness: 1,
                  color: AppTheme.mediumGreen.withValues(alpha: 0.2),
                  indent: 56,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSettingItem(_SettingItem item) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.actionYellow.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                item.icon,
                size: 20,
                color: AppTheme.actionYellow,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  if (item.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (item.trailing != null)
              item.trailing!
            else
              Icon(
                Icons.chevron_right,
                color: Colors.white.withValues(alpha: 0.3),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () => _showLogoutDialog(context),
        icon: const Icon(Icons.logout, size: 20),
        label: const Text(
          'Logout',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.sentRed,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          shadowColor: AppTheme.sentRed.withValues(alpha: 0.4),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Coming soon!'),
        backgroundColor: AppTheme.mediumGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardGreen,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'About Zentra',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version 1.0.0',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Zentra is your modern banking solution for seamless financial management.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 13,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(color: AppTheme.actionYellow),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardGreen,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Logout',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authServiceProvider).signOut();
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Logged out successfully'),
                  backgroundColor: AppTheme.receivedGreen,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            child: Text(
              'Logout',
              style: TextStyle(color: AppTheme.sentRed),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helper Classes ─────────────────────────────────────────────────────────

class _SettingItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  _SettingItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
  });
}

// ── Animated Widgets ───────────────────────────────────────────────────────

class _StaggeredAnimation extends StatefulWidget {
  final Widget child;
  final int delay;

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
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
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
