import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

// =============================================================================
// MOCK DATA MODELS
// =============================================================================
class MockUser {
  final String id, username, email, status, role;
  final double balance;
  const MockUser({
    required this.id,
    required this.username,
    required this.email,
    required this.balance,
    required this.status,
    required this.role,
  });
}

class ActivityItem {
  final String icon, title, subtitle, time;
  final Color color;
  const ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
  });
}

class AuditEntry {
  final String admin, action, target, time;
  const AuditEntry({
    required this.admin,
    required this.action,
    required this.target,
    required this.time,
  });
}

class MockData {
  static const users = [
    MockUser(
        id: 'USR001',
        username: 'alex_morgan',
        email: 'alex@bank.com',
        balance: 12480.50,
        status: 'Active',
        role: 'User'),
    MockUser(
        id: 'USR002',
        username: 'jamie_chen',
        email: 'jamie@bank.com',
        balance: 8920.00,
        status: 'Active',
        role: 'User'),
    MockUser(
        id: 'USR003',
        username: 'riley_patel',
        email: 'riley@bank.com',
        balance: 31200.75,
        status: 'Frozen',
        role: 'User'),
    MockUser(
        id: 'USR004',
        username: 'sam_kowalski',
        email: 'sam@bank.com',
        balance: 5640.20,
        status: 'Active',
        role: 'Admin'),
    MockUser(
        id: 'USR005',
        username: 'dana_ibrahim',
        email: 'dana@bank.com',
        balance: 19870.30,
        status: 'Active',
        role: 'User'),
    MockUser(
        id: 'USR006',
        username: 'morgan_liu',
        email: 'morgan@bank.com',
        balance: 2100.00,
        status: 'Frozen',
        role: 'User'),
    MockUser(
        id: 'USR007',
        username: 'casey_rivera',
        email: 'casey@bank.com',
        balance: 44500.00,
        status: 'Active',
        role: 'User'),
  ];

  static final activities = [
    ActivityItem(
        icon: '👤',
        title: 'New registration',
        subtitle: 'jordan_kim joined',
        time: '2 min ago',
        color: AppTheme.receivedGreen),
    ActivityItem(
        icon: '💰',
        title: 'Deposit received',
        subtitle: '3,400FCFA — alex_morgan',
        time: '8 min ago',
        color: AppTheme.actionYellow),
    ActivityItem(
        icon: '↗️',
        title: 'Transfer completed',
        subtitle: '780FCFA — jamie_chen',
        time: '15 min ago',
        color: AppTheme.darkGreen),
    ActivityItem(
        icon: '🏆',
        title: 'Quiz reward paid',
        subtitle: '50 points — dana_ibrahim',
        time: '22 min ago',
        color: AppTheme.accentGreen),
    ActivityItem(
        icon: '🔒',
        title: 'Account frozen',
        subtitle: 'morgan_liu — Admin Sam',
        time: '1 hr ago',
        color: AppTheme.sentRed),
    ActivityItem(
        icon: '⚙️',
        title: 'Admin action',
        subtitle: 'Balance adjusted — USR004',
        time: '2 hr ago',
        color: AppTheme.textMuted),
    ActivityItem(
        icon: '💸',
        title: 'Large withdrawal',
        subtitle: '12,000FCFA — casey_rivera',
        time: '3 hr ago',
        color: AppTheme.accentGreen),
  ];

  static const audits = [
    AuditEntry(
        admin: 'Sam Kowalski',
        action: 'Froze account',
        target: 'morgan_liu',
        time: '1 hr ago'),
    AuditEntry(
        admin: 'Sam Kowalski',
        action: 'Adjusted balance',
        target: 'USR004',
        time: '2 hr ago'),
    AuditEntry(
        admin: 'System',
        action: 'Auto-flagged txn',
        target: 'casey_rivera',
        time: '3 hr ago'),
    AuditEntry(
        admin: 'Sam Kowalski',
        action: 'Created admin role',
        target: 'dana_ibrahim',
        time: 'Yesterday'),
    AuditEntry(
        admin: 'System',
        action: 'Generated report',
        target: 'All users',
        time: 'Yesterday'),
  ];

  // Chart data (monthly — Jan to Jun)
  static const depositData = [
    42000.0,
    58000.0,
    51000.0,
    73000.0,
    68000.0,
    91000.0
  ];
  static const transferData = [
    31000.0,
    44000.0,
    38000.0,
    52000.0,
    49000.0,
    67000.0
  ];
  static const rewardData = [1200.0, 1800.0, 2100.0, 2600.0, 3100.0, 3800.0];
  static const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
}

// =============================================================================
// MAIN ADMIN DASHBOARD SCREEN
// =============================================================================
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.pageBg,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 1100;
            final isTablet = constraints.maxWidth >= 680;
            return CustomScrollView(
              slivers: [
                _buildSliverAppBar(context),
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 40 : (isTablet ? 24 : 16),
                    vertical: 8,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // 1. Overview cards
                      _SectionHeader(title: 'Overview', icon: '📊'),
                      const SizedBox(height: 16),
                      _OverviewGrid(isTablet: isTablet, isWide: isWide),
                      const SizedBox(height: 32),

                      // 2. Financial analytics
                      _SectionHeader(title: 'Financial Analytics', icon: '📈'),
                      const SizedBox(height: 16),
                      _AnalyticsSection(isTablet: isTablet, isWide: isWide),
                      const SizedBox(height: 32),

                      // 3. Quick Actions
                      _SectionHeader(title: 'Quick Actions', icon: '⚡'),
                      const SizedBox(height: 16),
                      _QuickActionsGrid(isTablet: isTablet, isWide: isWide),
                      const SizedBox(height: 32),

                      // 4. System Health
                      _SectionHeader(title: 'System Health', icon: '🖥️'),
                      const SizedBox(height: 16),
                      const _SystemHealthSection(),
                      const SizedBox(height: 32),

                      // 5. User Management
                      _SectionHeader(title: 'User Management', icon: '👥'),
                      const SizedBox(height: 16),
                      _UserManagementSection(
                        searchController: _searchController,
                        searchQuery: _searchQuery,
                        onSearch: (q) => setState(() => _searchQuery = q),
                        isTablet: isTablet,
                      ),
                      const SizedBox(height: 32),

                      // 6. Activity + Audit row
                      isWide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Expanded(child: _ActivityFeed()),
                                SizedBox(width: 24),
                                Expanded(child: _AuditLogPreview()),
                              ],
                            )
                          : Column(
                              children: const [
                                _ActivityFeed(),
                                SizedBox(height: 32),
                                _AuditLogPreview(),
                              ],
                            ),
                      const SizedBox(height: 48),
                    ]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: AppTheme.cardGreen,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppTheme.darkGreen, AppTheme.mediumGreen],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  // Avatar
                  _AdminAvatar(),
                  const SizedBox(width: 16),
                  // Greeting
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Good morning,',
                            style: AppTheme.bodySmall.copyWith(
                                color: AppTheme.actionYellow
                                    .withValues(alpha: 0.8))),
                        Text('Admin Sam 👋',
                            style: AppTheme.headingMedium.copyWith(
                                color: AppTheme.textLight,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  // Actions
                  _AppBarIconButton(
                    icon: Icons.notifications_rounded,
                    badge: '3',
                    onTap: () {},
                  ),
                  const SizedBox(width: 8),
                  _AppBarIconButton(
                    icon: Icons.settings_rounded,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// APP BAR WIDGETS
// =============================================================================
class _AdminAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppTheme.actionYellow, AppTheme.accentGreen],
        ),
        border: Border.all(
            color: AppTheme.textLight.withValues(alpha: 0.3), width: 2),
        boxShadow: [
          BoxShadow(
              color: AppTheme.actionYellow.withValues(alpha: 0.4),
              blurRadius: 12,
              spreadRadius: 2),
        ],
      ),
      child: Center(
        child: Text('SK',
            style: AppTheme.labelBold.copyWith(
                fontSize: 18,
                color: AppTheme.darkGreen,
                fontWeight: FontWeight.w800)),
      ),
    );
  }
}

class _AppBarIconButton extends StatelessWidget {
  final IconData icon;
  final String? badge;
  final VoidCallback onTap;
  const _AppBarIconButton({required this.icon, this.badge, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.textLight.withValues(alpha: 0.12),
          border:
              Border.all(color: AppTheme.textLight.withValues(alpha: 0.2)),
        ),
        child: Stack(
          children: [
            Center(
                child:
                    Icon(icon, color: AppTheme.textLight, size: 22)),
            if (badge != null)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: AppTheme.sentRed),
                  child: Center(
                    child: Text(badge!,
                        style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: Colors.white)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// SECTION HEADER
// =============================================================================
class _SectionHeader extends StatelessWidget {
  final String title, icon;
  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 8),
        Text(title,
            style: AppTheme.headingLarge
                .copyWith(color: Colors.white, fontSize: 22)),
        const SizedBox(width: 8),
        Expanded(
            child: Container(
                height: 1, color: AppTheme.textMuted.withValues(alpha: 0.2))),
      ],
    );
  }
}

// =============================================================================
// OVERVIEW CARDS GRID
// =============================================================================
class _OverviewGrid extends StatelessWidget {
  final bool isTablet, isWide;
  const _OverviewGrid({required this.isTablet, required this.isWide});

  @override
  Widget build(BuildContext context) {
    final cards = [
      _OverviewCardData(
        title: 'Total Liquidity',
        value: '2,847,320FCFA',
        sub: '+12.4% this month',
        icon: '💵',
        gradient: const LinearGradient(
            colors: [AppTheme.darkGreen, AppTheme.mediumGreen]),
        valueColor: AppTheme.actionYellow,
        trend: TrendDirection.up,
      ),
      _OverviewCardData(
        title: 'Total Users',
        value: '14,820',
        sub: '+248 this week',
        icon: '👥',
        gradient: const LinearGradient(
            colors: [AppTheme.mediumGreen, AppTheme.darkGreen]),
        valueColor: AppTheme.textLight,
        trend: TrendDirection.up,
      ),
      _OverviewCardData(
        title: 'Active Accounts',
        value: '13,104',
        sub: '88.4% of total',
        icon: '✅',
        gradient: LinearGradient(
            colors: [
              AppTheme.receivedGreen.withValues(alpha: 0.85),
              AppTheme.receivedGreen
            ]),
        valueColor: AppTheme.textLight,
        trend: TrendDirection.neutral,
      ),
      _OverviewCardData(
        title: 'Frozen Accounts',
        value: '1,716',
        sub: '↑ 34 from last week',
        icon: '🔒',
        gradient: LinearGradient(colors: [
          AppTheme.sentRed.withValues(alpha: 0.85),
          AppTheme.sentRed
        ]),
        valueColor: AppTheme.textLight,
        trend: TrendDirection.down,
      ),
    ];

    if (isWide) {
      return Row(
        children: cards
            .asMap()
            .entries
            .map((e) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: e.key < 3 ? 16 : 0),
                    child: _OverviewCard(data: e.value, delay: e.key * 100),
                  ),
                ))
            .toList(),
      );
    }
    if (isTablet) {
      return Column(
        children: [
          Row(children: [
            Expanded(child: _OverviewCard(data: cards[0], delay: 0)),
            const SizedBox(width: 16),
            Expanded(child: _OverviewCard(data: cards[1], delay: 100)),
          ]),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: _OverviewCard(data: cards[2], delay: 200)),
            const SizedBox(width: 16),
            Expanded(child: _OverviewCard(data: cards[3], delay: 300)),
          ]),
        ],
      );
    }
    return Column(
      children: cards
          .asMap()
          .entries
          .map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _OverviewCard(data: e.value, delay: e.key * 100),
              ))
          .toList(),
    );
  }
}

enum TrendDirection { up, down, neutral }

class _OverviewCardData {
  final String title, value, sub, icon;
  final Gradient gradient;
  final Color valueColor;
  final TrendDirection trend;
  const _OverviewCardData({
    required this.title,
    required this.value,
    required this.sub,
    required this.icon,
    required this.gradient,
    required this.valueColor,
    required this.trend,
  });
}

class _OverviewCard extends StatefulWidget {
  final _OverviewCardData data;
  final int delay;
  const _OverviewCard({required this.data, required this.delay});

  @override
  State<_OverviewCard> createState() => _OverviewCardState();
}

class _OverviewCardState extends State<_OverviewCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _slide, _fade;
  bool _hovering = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _slide = Tween(begin: 30.0, end: 0.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) => Opacity(
        opacity: _fade.value,
        child: Transform.translate(
          offset: Offset(0, _slide.value),
          child: child,
        ),
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: AnimatedScale(
          scale: _hovering ? 1.025 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: widget.data.gradient,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: _hovering ? 0.2 : 0.1),
                  blurRadius: _hovering ? 20 : 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:
                          Text(widget.data.icon, style: const TextStyle(fontSize: 22)),
                    ),
                    _TrendBadge(direction: widget.data.trend),
                  ],
                ),
                const SizedBox(height: 24),
                Text(widget.data.value,
                    style: AppTheme.balanceAmount.copyWith(
                        fontSize: 28,
                        color: widget.data.valueColor,
                        letterSpacing: -1)),
                const SizedBox(height: 4),
                Text(widget.data.title,
                    style: AppTheme.bodySmall.copyWith(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.75))),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(widget.data.sub,
                      style: AppTheme.bodySmall.copyWith(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.85))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TrendBadge extends StatelessWidget {
  final TrendDirection direction;
  const _TrendBadge({required this.direction});

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (direction) {
      TrendDirection.up => (Icons.trending_up_rounded, AppTheme.actionYellow),
      TrendDirection.down => (Icons.trending_down_rounded, AppTheme.sentRed),
      TrendDirection.neutral =>
        (Icons.trending_flat_rounded, AppTheme.textLight),
    };
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }
}

// =============================================================================
// FINANCIAL ANALYTICS
// =============================================================================
class _AnalyticsSection extends StatelessWidget {
  final bool isTablet, isWide;
  const _AnalyticsSection({required this.isTablet, required this.isWide});

  @override
  Widget build(BuildContext context) {
    final charts = [
      _ChartCardData(
        title: 'Monthly Deposits',
        subtitle: '91k FCFA peak in June',
        data: MockData.depositData,
        color: AppTheme.actionYellow,
        prefix: '',
      ),
      _ChartCardData(
        title: 'Monthly Transfers',
        subtitle: '67k FCFA in June',
        data: MockData.transferData,
        color: AppTheme.receivedGreen,
        prefix: '',
      ),
      _ChartCardData(
        title: 'Quiz Rewards',
        subtitle: '3.8k points paid in June',
        data: MockData.rewardData,
        color: AppTheme.accentGreen,
        prefix: '',
      ),
    ];

    if (isWide) {
      return Row(
        children: charts
            .asMap()
            .entries
            .map((e) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: e.key < 2 ? 16 : 0),
                    child: _ChartCard(data: e.value),
                  ),
                ))
            .toList(),
      );
    }
    return Column(
      children: charts
          .map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _ChartCard(data: c),
              ))
          .toList(),
    );
  }
}

class _ChartCardData {
  final String title, subtitle, prefix;
  final List<double> data;
  final Color color;
  const _ChartCardData({
    required this.title,
    required this.subtitle,
    required this.data,
    required this.color,
    required this.prefix,
  });
}

class _ChartCard extends StatefulWidget {
  final _ChartCardData data;
  const _ChartCard({required this.data});

  @override
  State<_ChartCard> createState() => _ChartCardState();
}

class _ChartCardState extends State<_ChartCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _progress = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.cardGreen,
        borderRadius: BorderRadius.circular(24),=> Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.color.withValues(alpha: 0.4 + 0.6 * _anim.value),
          boxShadow: [
            BoxShadow(
                color: widget.color.withValues(alpha: 0.6 * _anim.value),
                blurRadius: 6,
                spreadRadius: 2),
          ],
        ),
      ),
    );
  }
}
oller _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __)                        color: color,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          // Pulse dot
          _PulseDot(color: color),
        ],
      ),
    );
  }
}

class _PulseDot extends StatefulWidget {
  final Color color;
  const _PulseDot({required this.color});

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late AnimationControlor.withValues(alpha: 0.15),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.name,
                    style: AppTheme.labelBold.copyWith(color: Colors.white)),
                Text(label,
                    style: AppTheme.bodySmall.copyWith(
                        fontSize: 11,
 ,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1.5),
        boxShadow: [
          BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: c  Widget build(BuildContext context) {
    final (color, icon, label) = switch (data.status) {
      _ServiceStatus.healthy =>
        (AppTheme.receivedGreen, Icons.check_circle_rounded, 'Healthy'),
      _ServiceStatus.warning =>
        (AppTheme.accentGreen, Icons.warning_rounded, 'Warning'),
      _ServiceStatus.error => (AppTheme.sentRed, Icons.error_rounded, 'Error'),
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardGreen   return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: services
            .map((s) => SizedBox(width: w, child: _ServiceCard(data: s)))
            .toList(),
      );
    });
  }
}

enum _ServiceStatus { healthy, warning, error }

class _ServiceData {
  final String name;
  final _ServiceStatus status;
  const _ServiceData(this.name, this.status);
}

class _ServiceCard extends StatelessWidget {
  final _ServiceData data;
  const _ServiceCard({required this.data});

  @override
c const services = [
    _ServiceData('Server', _ServiceStatus.healthy),
    _ServiceData('Database', _ServiceStatus.healthy),
    _ServiceData('Auth Service', _ServiceStatus.warning),
    _ServiceData('API Gateway', _ServiceStatus.healthy),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final cols = constraints.maxWidth > 600 ? 4 : 2;
      final spacing = 12.0;
      final w = (constraints.maxWidth - spacing * (cols - 1)) / cols;
        .copyWith(color: AppTheme.textMuted),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// SYSTEM HEALTH SECTION
// =============================================================================
class _SystemHealthSection extends StatelessWidget {
  const _SystemHealthSection();

  stati   ),
                    child:
                        Icon(widget.data.icon, color: widget.data.color, size: 22),
                  ),
                  const SizedBox(height: 8),
                  Text(widget.data.title,
                      style: AppTheme.labelBold.copyWith(
                          fontWeight: FontWeight.w700, color: Colors.white)),
                  const SizedBox(height: 2),
                  Text(widget.data.desc,
                      style: AppTheme.bodySmall
                     : _hovering ? 16 : 8,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: widget.data.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                       : AppTheme.cardGreen,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: _hovering
                      ? widget.data.color.withValues(alpha: 0.4)
                      : Colors.transparent,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black
                          .withValues(alpha: _hovering ? 0.1 : 0.05),
                      blurRadiusl: () => setState(() => _pressing = false),
          onTap: () {},
          child: AnimatedScale(
            scale: _pressing ? 0.95 : (_hovering ? 1.03 : 1.0),
            duration: const Duration(milliseconds: 150),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _hovering
                    ? widget.data.color.withValues(alpha: 0.12)
              edBuilder(
      animation: _ctrl,
      builder: (_, child) => Opacity(
        opacity: _fade.value,
        child: Transform.translate(offset: Offset(0, _slide.value), child: child),
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressing = true),
          onTapUp: (_) => setState(() => _pressing = false),
          onTapCanceroller(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _slide = Tween(begin: 20.0, end: 0.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatefulWidget {
  final _ActionData data;
  final int delay;
  const _QuickActionCard({required this.data, required this.delay});

  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard>
    with SingleTickerProviderStateMixin {
  bool _hovering = false, _pressing = false;
  late AnimationController _ctrl;
  late Animation<double> _fade, _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationCont: actions
            .asMap()
            .entries
            .map((e) => SizedBox(
                  width: cardW,
                  child: _QuickActionCard(data: e.value, delay: e.key * 80),
                ))
            .toList(),
      );
    });
  }
}

class _ActionData {
  final IconData icon;
  final String title, desc;
  final Color color;
  const _ActionData({
    required this.icon,
    required this.title,
    required this.desc,
    required this.color,
  });
}

class _QuickActionCard extends Stat    _ActionData(
        icon: Icons.history_rounded,
        title: 'Audit Logs',
        desc: 'Review all admin actions',
        color: AppTheme.textMuted),
  ];

  @override
  Widget build(BuildContext context) {
    final cols = isWide ? 6 : (isTablet ? 3 : 2);
    return LayoutBuilder(builder: (context, constraints) {
      final spacing = 12.0;
      final cardW = (constraints.maxWidth - spacing * (cols - 1)) / cols;
      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        childrenreen),
    _ActionData(
        icon: Icons.lock_rounded,
        title: 'Freeze User',
        desc: 'Suspend account access',
        color: AppTheme.sentRed),
    _ActionData(
        icon: Icons.admin_panel_settings_rounded,
        title: 'Create Admin',
        desc: 'Assign admin privileges',
        color: AppTheme.accentGreen),
    _ActionData(
        icon: Icons.file_download_rounded,
        title: 'Export Reports',
        desc: 'Download financial data',
        color: AppTheme.receivedGreen),
==========
class _QuickActionsGrid extends StatelessWidget {
  final bool isTablet, isWide;
  const _QuickActionsGrid({required this.isTablet, required this.isWide});

  static const actions = [
    _ActionData(
        icon: Icons.add_circle_rounded,
        title: 'Add Funds',
        desc: 'Deposit to any account',
        color: AppTheme.darkGreen),
    _ActionData(
        icon: Icons.edit_rounded,
        title: 'Adjust Balance',
        desc: 'Manually update balance',
        color: AppTheme.mediumG canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(x, y, barW, barH),
          topLeft: const Radius.circular(6),
          topRight: const Radius.circular(6),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_BarChartPainter old) =>
      old.progress != progress || old.color != color;
}

// =============================================================================
// QUICK ACTIONS PANEL
// ===================================================================lor = color.withValues(alpha: 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(x, y + 4, barW, barH), const Radius.circular(6)),
        shadowPaint,
      );

      // Gradient bar
      paint.shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color, color.withValues(alpha: 0.5)],
      ).createShader(Rect.fromLTWH(x, y, barW, barH));

       ..color = Colors.white.withValues(alpha: 0.06)
      ..strokeWidth = 1;

    // Grid lines
    for (int i = 1; i <= 4; i++) {
      final y = size.height - (size.height * (i / 4));
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Bars
    for (int i = 0; i < data.length; i++) {
      final barH = (data[i] / maxVal) * size.height * progress;
      final x = i * (barW + 8);
      final y = size.height - barH;

      // Shadow
      final shadowPaint = Paint()
        ..co      ),
        ],
      ),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<double> data;
  final Color color;
  final double progress;
  const _BarChartPainter({
    required this.data,
    required this.color,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final maxVal = data.reduce(max);
    final barW = (size.width - (data.length - 1) * 8) / data.length;
    final paint = Paint()..style = PaintingStyle.fill;
    final gridPaint = Paint()
                      progress: _progress.value,
                ),
                size: Size.infinite,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Month labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: MockData.months
                .map((m) => Text(m,
                    style: AppTheme.bodySmall
                        .copyWith(color: AppTheme.textMuted, fontSize: 10)))
                .toList(),
    0,
                height: 10,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: widget.data.color),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 140,
            child: AnimatedBuilder(
              animation: _progress,
              builder: (_, __) => CustomPaint(
                painter: _BarChartPainter(
                  data: widget.data.data,
                  color: widget.data.color,
                children: [
                    Text(widget.data.title,
                        style: AppTheme.labelBold
                            .copyWith(color: Colors.white, fontSize: 16)),
                    const SizedBox(height: 2),
                    Text(widget.data.subtitle,
                        style: AppTheme.bodySmall
                            .copyWith(color: AppTheme.textMuted)),
                  ],
                ),
              ),
              Container(
                width: 1
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 16,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
  