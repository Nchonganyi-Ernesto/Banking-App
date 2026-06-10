// =============================================================================
// AdminDashboardScreen.dart
// Banking & Financial Literacy App — Admin Dashboard
// Adapted for Zentra theme (Dark Green + Neon Yellow)
// =============================================================================

import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

// =============================================================================
// DESIGN TOKENS - Adapted to match Zentra theme
// =============================================================================
class AdminColors {
  // Using Zentra colors
  static const primaryDark    = AppTheme.darkGreen;      // 0xFF0F3122
  static const secondaryDark  = AppTheme.mediumGreen;    // 0xFF1B4230
  static const mediumGreen    = AppTheme.mediumGreen;    // 0xFF1B4230
  static const accentYellow   = AppTheme.actionYellow;   // 0xFFD8FA3C
  static const secondaryYellow= AppTheme.accentGreen;    // 0xFFD8FA3C
  static const amberAccent    = Color(0xFFF3A93B);
  static const warmCream      = Color(0xFFF1F5E8);
  static const softCream      = Color(0xFFEBF0E1);
  static const mintTint       = Color(0xFFDFE8D4);
  static const white          = AppTheme.textLight;
  static const charcoal       = AppTheme.textDark;
  static const mutedSageGrey  = AppTheme.textMuted;
  static const successGreen   = AppTheme.receivedGreen;
  static const alertRed       = AppTheme.sentRed;
  static const pageBg         = AppTheme.pageBg;

  // Chart colors
  static const chartGreen1    = Color(0xFF2D7A5F);
  static const chartGreen2    = AppTheme.receivedGreen;
  static const chartYellow    = AppTheme.actionYellow;
  static const chartAmber     = Color(0xFFF3A93B);
}

class AppSpacing {
  static const xs  = 4.0;
  static const sm  = 8.0;
  static const md  = 16.0;
  static const lg  = 24.0;
  static const xl  = 32.0;
  static const xxl = 48.0;
}

class AppRadius {
  static const sm  = 12.0;
  static const md  = 16.0;
  static const lg  = 20.0;
  static const xl  = 24.0;
  static const xxl = 28.0;
}

// =============================================================================
// MOCK DATA MODELS
// =============================================================================
class MockUser {
  final String id, username, email, status, role;
  final double balance;
  const MockUser({
    required this.id, required this.username, required this.email,
    required this.balance, required this.status, required this.role,
  });
}

class ActivityItem {
  final String icon, title, subtitle, time;
  final Color color;
  const ActivityItem({
    required this.icon, required this.title,
    required this.subtitle, required this.time, required this.color,
  });
}

class AuditEntry {
  final String admin, action, target, time;
  const AuditEntry({
    required this.admin, required this.action,
    required this.target, required this.time,
  });
}

class MockData {
  static const users = [
    MockUser(id:'USR001', username:'alex_morgan',    email:'alex@bank.com',    balance:12480.50, status:'Active',  role:'User'),
    MockUser(id:'USR002', username:'jamie_chen',     email:'jamie@bank.com',   balance:8920.00,  status:'Active',  role:'User'),
    MockUser(id:'USR003', username:'riley_patel',    email:'riley@bank.com',   balance:31200.75, status:'Frozen',  role:'User'),
    MockUser(id:'USR004', username:'sam_kowalski',   email:'sam@bank.com',     balance:5640.20,  status:'Active',  role:'Admin'),
    MockUser(id:'USR005', username:'dana_ibrahim',   email:'dana@bank.com',    balance:19870.30, status:'Active',  role:'User'),
    MockUser(id:'USR006', username:'morgan_liu',     email:'morgan@bank.com',  balance:2100.00,  status:'Frozen',  role:'User'),
    MockUser(id:'USR007', username:'casey_rivera',   email:'casey@bank.com',   balance:44500.00, status:'Active',  role:'User'),
  ];

  static const activities = [
    ActivityItem(icon:'👤', title:'New registration',   subtitle:'jordan_kim joined',       time:'2 min ago',  color:AdminColors.successGreen),
    ActivityItem(icon:'💰', title:'Deposit received',   subtitle:'3,400FCFA — alex_morgan',   time:'8 min ago',  color:AdminColors.accentYellow),
    ActivityItem(icon:'↗️', title:'Transfer completed', subtitle:'780FCFA — jamie_chen',      time:'15 min ago', color:AdminColors.chartGreen1),
    ActivityItem(icon:'🏆', title:'Quiz reward paid',   subtitle:'50FCFA — dana_ibrahim',     time:'22 min ago', color:AdminColors.amberAccent),
    ActivityItem(icon:'🔒', title:'Account frozen',     subtitle:'morgan_liu — Admin Sam',  time:'1 hr ago',   color:AdminColors.alertRed),
    ActivityItem(icon:'⚙️', title:'Admin action',       subtitle:'Balance adjusted — USR004',time:'2 hr ago', color:AdminColors.mutedSageGrey),
    ActivityItem(icon:'�', title:'Large withdrawal',   subtitle:'12,000FCFA — casey_rivera', time:'3 hr ago',   color:AdminColors.amberAccent),
  ];

  static const audits = [
    AuditEntry(admin:'Sam Kowalski', action:'Froze account',      target:'morgan_liu',  time:'1 hr ago'),
    AuditEntry(admin:'Sam Kowalski', action:'Adjusted balance',   target:'USR004',      time:'2 hr ago'),
    AuditEntry(admin:'System',       action:'Auto-flagged txn',    target:'casey_rivera',time:'3 hr ago'),
    AuditEntry(admin:'Sam Kowalski', action:'Created admin role',  target:'dana_ibrahim',time:'Yesterday'),
    AuditEntry(admin:'System',       action:'Generated report',    target:'All users',   time:'Yesterday'),
  ];

  // Chart data (monthly — Jan to Jun)
  static const depositData  = [42000.0, 58000.0, 51000.0, 73000.0, 68000.0, 91000.0];
  static const transferData = [31000.0, 44000.0, 38000.0, 52000.0, 49000.0, 67000.0];
  static const rewardData   = [1200.0,  1800.0,  2100.0,  2600.0,  3100.0,  3800.0];
  static const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
}

// =============================================================================
// MAIN DASHBOARD SCREEN
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
      vsync: this, duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController, curve: Curves.easeOutCubic,
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
    return _buildScaffold(context);
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.pageBg,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide   = constraints.maxWidth >= 1100;
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
                      const SizedBox(height: AppSpacing.md),
                      _OverviewGrid(isTablet: isTablet, isWide: isWide),
                      const SizedBox(height: AppSpacing.xl),

                      // 2. Financial analytics
                      _SectionHeader(title: 'Financial Analytics', icon: '📈'),
                      const SizedBox(height: AppSpacing.md),
                      _AnalyticsSection(isTablet: isTablet, isWide: isWide),
                      const SizedBox(height: AppSpacing.xl),

                      // 3. Quick Actions
                      _SectionHeader(title: 'Quick Actions', icon: '⚡'),
                      const SizedBox(height: AppSpacing.md),
                      _QuickActionsGrid(isTablet: isTablet, isWide: isWide),
                      const SizedBox(height: AppSpacing.xl),

                      // 4. System Health
                      _SectionHeader(title: 'System Health', icon: '🖥️'),
                      const SizedBox(height: AppSpacing.md),
                      const _SystemHealthSection(),
                      const SizedBox(height: AppSpacing.xl),

                      // 5. User Management
                      _SectionHeader(title: 'User Management', icon: '👥'),
                      const SizedBox(height: AppSpacing.md),
                      _UserManagementSection(
                        searchController: _searchController,
                        searchQuery: _searchQuery,
                        onSearch: (q) => setState(() => _searchQuery = q),
                        isTablet: isTablet,
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // 6. Activity + Audit row
                      isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Expanded(child: _ActivityFeed()),
                              const SizedBox(width: AppSpacing.lg),
                              const Expanded(child: _AuditLogPreview()),
                            ],
                          )
                        : Column(
                            children: const [
                              _ActivityFeed(),
                              SizedBox(height: AppSpacing.xl),
                              _AuditLogPreview(),
                            ],
                          ),
                      const SizedBox(height: AppSpacing.xxl),
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
      backgroundColor: AdminColors.primaryDark,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AdminColors.primaryDark, AdminColors.mediumGreen],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              child: Row(
                children: [
                  // Avatar
                  _AdminAvatar(),
                  const SizedBox(width: AppSpacing.md),
                  // Greeting
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Good morning,',
                          style: AppTheme.bodySmall.copyWith(
                            color: AdminColors.accentYellow.withValues(alpha: 0.8))),
                        Text('Admin Sam 👋',
                          style: AppTheme.headingMedium.copyWith(
                            color: AdminColors.white, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  // Actions
                  _AppBarIconButton(
                    icon: Icons.notifications_rounded,
                    badge: '3',
                    onTap: () {},
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _AppBarIconButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: () => Navigator.pop(context),
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
      width: 52, height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AdminColors.accentYellow, AdminColors.amberAccent],
        ),
        border: Border.all(color: AdminColors.white.withValues(alpha: 0.3), width: 2),
        boxShadow: [
          BoxShadow(color: AdminColors.accentYellow.withValues(alpha: 0.4),
            blurRadius: 12, spreadRadius: 2),
        ],
      ),
      child: const Center(
        child: Text('SK',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800,
            color: AdminColors.primaryDark)),
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
        width: 44, height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AdminColors.white.withValues(alpha: 0.12),
          border: Border.all(color: AdminColors.white.withValues(alpha: 0.2)),
        ),
        child: Stack(
          children: [
            Center(child: Icon(icon, color: AdminColors.white, size: 22)),
            if (badge != null)
              Positioned(
                top: 6, right: 6,
                child: Container(
                  width: 16, height: 16,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: AdminColors.alertRed),
                  child: Center(
                    child: Text(badge!,
                      style: const TextStyle(
                        fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white)),
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
        const SizedBox(width: AppSpacing.sm),
        Text(title,
          style: AppTheme.headingLarge.copyWith(
            color: AdminColors.white, fontSize: 22)),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Container(height: 1,
          color: AdminColors.mutedSageGrey.withValues(alpha: 0.2))),
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
          colors: [AdminColors.primaryDark, AdminColors.mediumGreen]),
        valueColor: AdminColors.accentYellow,
        trend: TrendDirection.up,
      ),
      _OverviewCardData(
        title: 'Total Users',
        value: '14,820',
        sub: '+248 this week',
        icon: '👥',
        gradient: const LinearGradient(
          colors: [Color(0xFF1A5C42), Color(0xFF235347)]),
        valueColor: AdminColors.white,
        trend: TrendDirection.up,
      ),
      _OverviewCardData(
        title: 'Active Accounts',
        value: '13,104',
        sub: '88.4% of total',
        icon: '✅',
        gradient: LinearGradient(
          colors: [AdminColors.successGreen.withValues(alpha: 0.85),
                   const Color(0xFF2E7D52)]),
        valueColor: AdminColors.white,
        trend: TrendDirection.neutral,
      ),
      _OverviewCardData(
        title: 'Frozen Accounts',
        value: '1,716',
        sub: '↑ 34 from last week',
        icon: '🔒',
        gradient: LinearGradient(
          colors: [AdminColors.alertRed.withValues(alpha: 0.85),
                   const Color(0xFFC0392B)]),
        valueColor: AdminColors.white,
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
    required this.title, required this.value, required this.sub,
    required this.icon, required this.gradient, required this.valueColor,
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
    _slide = Tween(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

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
        onExit:  (_) => setState(() => _hovering = false),
        child: AnimatedScale(
          scale: _hovering ? 1.025 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: widget.data.gradient,
              borderRadius: BorderRadius.circular(AppRadius.xxl),
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
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Text(widget.data.icon,
                        style: const TextStyle(fontSize: 22)),
                    ),
                    _TrendBadge(direction: widget.data.trend),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(widget.data.value,
                  style: TextStyle(
                    fontSize: 28, fontWeight: FontWeight.w800,
                    color: widget.data.valueColor, letterSpacing: -1)),
                const SizedBox(height: 4),
                Text(widget.data.title,
                  style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.75))),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(widget.data.sub,
                    style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w500,
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
      TrendDirection.up      => (Icons.trending_up_rounded,    AdminColors.accentYellow),
      TrendDirection.down    => (Icons.trending_down_rounded,  AdminColors.alertRed),
      TrendDirection.neutral => (Icons.trending_flat_rounded,  AdminColors.white),
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
// FINANCIAL ANALYTICS (PURE FLUTTER CHARTS — NO EXTERNAL PACKAGE)
// =============================================================================
class _AnalyticsSection extends StatelessWidget {
  final bool isTablet, isWide;
  const _AnalyticsSection({required this.isTablet, required this.isWide});

  @override
  Widget build(BuildContext context) {
    final charts = [
      _ChartCardData(
        title: 'Monthly Deposits',
        subtitle: '91k peak in June',
        data: MockData.depositData,
        color: AdminColors.accentYellow,
        prefix: 'FCFA',
      ),
      _ChartCardData(
        title: 'Monthly Transfers',
        subtitle: '67k in June',
        data: MockData.transferData,
        color: AdminColors.chartGreen1,
        prefix: 'FCFA',
      ),
      _ChartCardData(
        title: 'Quiz Rewards',
        subtitle: '3.8k paid in June',
        data: MockData.rewardData,
        color: AdminColors.amberAccent,
        prefix: 'FCFA',
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
    required this.title, required this.subtitle,
    required this.data, required this.color, required this.prefix,
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
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AdminColors.secondaryDark,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16, offset: const Offset(0, 4)),
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
                  children: [
                    Text(widget.data.title,
                      style: AppTheme.labelBold.copyWith(
                        color: AdminColors.white, fontSize: 16)),
                    const SizedBox(height: 2),
                    Text(widget.data.subtitle,
                      style: AppTheme.bodySmall.copyWith(
                        color: AdminColors.mutedSageGrey)),
                  ],
                ),
              ),
              Container(
                width: 10, height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, color: widget.data.color),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 140,
            child: AnimatedBuilder(
              animation: _progress,
              builder: (_, _) => CustomPaint(
                painter: _BarChartPainter(
                  data: widget.data.data,
                  color: widget.data.color,
                  progress: _progress.value,
                ),
                size: Size.infinite,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Month labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: MockData.months
                .map((m) => Text(m,
                      style: AppTheme.bodySmall.copyWith(
                        color: AdminColors.mutedSageGrey, fontSize: 10)))
                .toList(),
          ),
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
    required this.data, required this.color,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final maxVal = data.reduce(max);
    final barW = (size.width - (data.length - 1) * 8) / data.length;
    final paint = Paint()..style = PaintingStyle.fill;
    final gridPaint = Paint()
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
        ..color = color.withValues(alpha: 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y + 4, barW, barH),
          const Radius.circular(6)),
        shadowPaint,
      );

      // Gradient bar
      paint.shader = LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [color, color.withValues(alpha: 0.5)],
      ).createShader(Rect.fromLTWH(x, y, barW, barH));

      canvas.drawRRect(
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
// =============================================================================
class _QuickActionsGrid extends StatelessWidget {
  final bool isTablet, isWide;
  const _QuickActionsGrid({required this.isTablet, required this.isWide});

  static const actions = [
    _ActionData(icon: Icons.add_circle_rounded,        title: 'Add Funds',           desc: 'Deposit to any account',       color: AdminColors.primaryDark),
    _ActionData(icon: Icons.edit_rounded,              title: 'Adjust Balance',       desc: 'Manually update balance',      color: AdminColors.mediumGreen),
    _ActionData(icon: Icons.lock_rounded,              title: 'Freeze User',          desc: 'Suspend account access',       color: AdminColors.alertRed),
    _ActionData(icon: Icons.admin_panel_settings_rounded, title: 'Create Admin',     desc: 'Assign admin privileges',      color: AdminColors.amberAccent),
    _ActionData(icon: Icons.file_download_rounded,     title: 'Export Reports',       desc: 'Download financial data',      color: AdminColors.chartGreen1),
    _ActionData(icon: Icons.history_rounded,           title: 'Audit Logs',           desc: 'Review all admin actions',     color: AdminColors.mutedSageGrey),
  ];

  @override
  Widget build(BuildContext context) {
    final cols = isWide ? 6 : (isTablet ? 3 : 2);
    return LayoutBuilder(builder: (context, constraints) {
      final spacing = 12.0;
      final cardW = (constraints.maxWidth - spacing * (cols - 1)) / cols;
      return Wrap(
        spacing: spacing, runSpacing: spacing,
        children: actions
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
    required this.icon, required this.title,
    required this.desc, required this.color,
  });
}

class _QuickActionCard extends StatefulWidget {
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
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _slide = Tween(begin: 20.0, end: 0.0).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) => Opacity(
        opacity: _fade.value,
        child: Transform.translate(offset: Offset(0, _slide.value), child: child),
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovering = true),
        onExit:  (_) => setState(() => _hovering = false),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressing = true),
          onTapUp:   (_) => setState(() => _pressing = false),
          onTapCancel: ()=> setState(() => _pressing = false),
          onTap: () {},
          child: AnimatedScale(
            scale: _pressing ? 0.95 : (_hovering ? 1.03 : 1.0),
            duration: const Duration(milliseconds: 150),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: _hovering
                    ? widget.data.color.withValues(alpha: 0.08)
                    : AdminColors.secondaryDark,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                border: Border.all(
                  color: _hovering
                      ? widget.data.color.withValues(alpha: 0.4)
                      : Colors.transparent,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: _hovering ? 0.1 : 0.05),
                    blurRadius: _hovering ? 16 : 8,
                    offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: widget.data.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Icon(widget.data.icon,
                      color: widget.data.color, size: 22),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(widget.data.title,
                    style: AppTheme.labelBold.copyWith(
                      fontWeight: FontWeight.w700, color: AdminColors.white)),
                  const SizedBox(height: 2),
                  Text(widget.data.desc,
                    style: AppTheme.bodySmall.copyWith(
                      color: AdminColors.mutedSageGrey),
                    maxLines: 2, overflow: TextOverflow.ellipsis),
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

  static const services = [
    _ServiceData('Server',             _ServiceStatus.healthy),
    _ServiceData('Database',           _ServiceStatus.healthy),
    _ServiceData('Auth Service',       _ServiceStatus.warning),
    _ServiceData('API Gateway',        _ServiceStatus.healthy),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final cols = constraints.maxWidth > 600 ? 4 : 2;
      final spacing = 12.0;
      final w = (constraints.maxWidth - spacing * (cols - 1)) / cols;
      return Wrap(
        spacing: spacing, runSpacing: spacing,
        children: services.map((s) =>
          SizedBox(width: w, child: _ServiceCard(data: s))).toList(),
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
  Widget build(BuildContext context) {
    final (color, icon, label) = switch (data.status) {
      _ServiceStatus.healthy => (AdminColors.successGreen, Icons.check_circle_rounded, 'Healthy'),
      _ServiceStatus.warning => (AdminColors.amberAccent,  Icons.warning_rounded,      'Warning'),
      _ServiceStatus.error   => (AdminColors.alertRed,     Icons.error_rounded,        'Error'),
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AdminColors.secondaryDark,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1.5),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.1),
            blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.name,
                  style: AppTheme.labelBold.copyWith(color: AdminColors.white)),
                Text(label,
                  style: TextStyle(fontSize: 11, color: color,
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
  late AnimationController _ctrl;
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
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, _) => Container(
        width: 10, height: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.color.withValues(alpha: 0.4 + 0.6 * _anim.value),
          boxShadow: [
            BoxShadow(
              color: widget.color.withValues(alpha: 0.6 * _anim.value),
              blurRadius: 6, spreadRadius: 2),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// USER MANAGEMENT SECTION
// =============================================================================
class _UserManagementSection extends StatefulWidget {
  final TextEditingController searchController;
  final String searchQuery;
  final ValueChanged<String> onSearch;
  final bool isTablet;

  const _UserManagementSection({
    required this.searchController, required this.searchQuery,
    required this.onSearch, required this.isTablet,
  });

  @override
  State<_UserManagementSection> createState() => _UserManagementSectionState();
}

class _UserManagementSectionState extends State<_UserManagementSection> {
  @override
  Widget build(BuildContext context) {
    final filtered = MockData.users.where((u) =>
      widget.searchQuery.isEmpty ||
      u.username.contains(widget.searchQuery.toLowerCase()) ||
      u.email.contains(widget.searchQuery.toLowerCase()) ||
      u.id.contains(widget.searchQuery.toUpperCase()),
    ).toList();

    return Container(
      decoration: BoxDecoration(
        color: AdminColors.secondaryDark,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: TextField(
              controller: widget.searchController,
              onChanged: widget.onSearch,
              style: TextStyle(color: AdminColors.white),
              decoration: InputDecoration(
                hintText: 'Search by username, email, or ID…',
                hintStyle: TextStyle(color: AdminColors.mutedSageGrey,
                  fontSize: 14),
                prefixIcon: const Icon(Icons.search_rounded,
                  color: AdminColors.mutedSageGrey),
                filled: true,
                fillColor: AdminColors.primaryDark.withValues(alpha: 0.4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: 12),
              ),
            ),
          ),
          // Table header
          _UserTableHeader(isTablet: widget.isTablet),
          // Rows
          ...filtered.asMap().entries.map((e) =>
            _UserTableRow(
              user: e.value,
              index: e.key,
              isTablet: widget.isTablet,
            )),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}

class _UserTableHeader extends StatelessWidget {
  final bool isTablet;
  const _UserTableHeader({required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AdminColors.primaryDark.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        children: [
          _HeaderCell('User', flex: 2),
          if (isTablet) _HeaderCell('Email', flex: 2),
          _HeaderCell('Balance', flex: 2),
          _HeaderCell('Status', flex: 1),
          _HeaderCell('Actions', flex: 2),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;
  final int flex;
  const _HeaderCell(this.label, {required this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(label,
        style: const TextStyle(
          fontSize: 11, fontWeight: FontWeight.w700,
          color: AdminColors.mutedSageGrey, letterSpacing: 0.8)),
    );
  }
}

class _UserTableRow extends StatefulWidget {
  final MockUser user;
  final int index;
  final bool isTablet;
  const _UserTableRow({
    required this.user, required this.index, required this.isTablet});

  @override
  State<_UserTableRow> createState() => _UserTableRowState();
}

class _UserTableRowState extends State<_UserTableRow> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.user.status == 'Active';

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit:  (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: 3),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm + 4),
        decoration: BoxDecoration(
          color: _hovering
              ? AdminColors.mediumGreen.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Row(
          children: [
            // User info
            Expanded(flex: 2, child: Row(
              children: [
                _MiniAvatar(name: widget.user.username, index: widget.index),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.user.username,
                        style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600,
                          color: AdminColors.white),
                        overflow: TextOverflow.ellipsis),
                      Text(widget.user.id,
                        style: const TextStyle(
                          fontSize: 10, color: AdminColors.mutedSageGrey)),
                    ],
                  ),
                ),
              ],
            )),
            // Email (tablet+)
            if (widget.isTablet)
              Expanded(flex: 2, child: Text(widget.user.email,
                style: const TextStyle(
                  fontSize: 12, color: AdminColors.mutedSageGrey),
                overflow: TextOverflow.ellipsis)),
            // Balance
            Expanded(flex: 2, child: Text(
              '${widget.user.balance.toStringAsFixed(2)}FCFA',
              style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w700,
                color: AdminColors.accentYellow))),
            // Status chip
            Expanded(flex: 1, child: _StatusChip(status: widget.user.status)),
            // Actions
            Expanded(flex: 2, child: Row(
              children: [
                _ActionIconBtn(
                  icon: Icons.visibility_rounded,
                  color: AdminColors.mediumGreen,
                  tooltip: 'View',
                  onTap: () {},
                ),
                _ActionIconBtn(
                  icon: Icons.edit_rounded,
                  color: AdminColors.amberAccent,
                  tooltip: 'Edit Balance',
                  onTap: () {},
                ),
                _ActionIconBtn(
                  icon: isActive
                      ? Icons.lock_rounded
                      : Icons.lock_open_rounded,
                  color: isActive ? AdminColors.alertRed : AdminColors.successGreen,
                  tooltip: isActive ? 'Freeze' : 'Unfreeze',
                  onTap: () {},
                ),
                _ActionIconBtn(
                  icon: Icons.delete_rounded,
                  color: AdminColors.alertRed,
                  tooltip: 'Delete',
                  onTap: () {},
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}

class _MiniAvatar extends StatelessWidget {
  final String name;
  final int index;
  const _MiniAvatar({required this.name, required this.index});

  static const _colors = [
    AdminColors.primaryDark, AdminColors.mediumGreen, AdminColors.chartGreen1,
    AdminColors.amberAccent, AdminColors.alertRed, AdminColors.mutedSageGrey,
  ];

  @override
  Widget build(BuildContext context) {
    final bg = _colors[index % _colors.length];
    final initials = name.length >= 2
        ? name.substring(0, 2).toUpperCase()
        : name.toUpperCase();
    return Container(
      width: 32, height: 32,
      decoration: BoxDecoration(shape: BoxShape.circle, color: bg),
      child: Center(child: Text(initials,
        style: const TextStyle(
          fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white))),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final isActive = status == 'Active';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? AdminColors.successGreen.withValues(alpha: 0.12)
            : AdminColors.alertRed.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(status,
        style: TextStyle(
          fontSize: 10, fontWeight: FontWeight.w700,
          color: isActive ? AdminColors.successGreen : AdminColors.alertRed)),
    );
  }
}

class _ActionIconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;
  const _ActionIconBtn({
    required this.icon, required this.color,
    required this.tooltip, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 28, height: 28, margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle, color: color.withValues(alpha: 0.1)),
          child: Icon(icon, size: 14, color: color),
        ),
      ),
    );
  }
}

// =============================================================================
// ACTIVITY FEED
// =============================================================================
class _ActivityFeed extends StatelessWidget {
  const _ActivityFeed();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AdminColors.secondaryDark,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('⚡', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text('Recent Activity',
                style: AppTheme.headingMedium.copyWith(
                  color: AdminColors.white, fontSize: 18)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...MockData.activities.asMap().entries.map((e) =>
            _ActivityTile(item: e.value, isLast: e.key == MockData.activities.length - 1)),
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final ActivityItem item;
  final bool isLast;
  const _ActivityTile({required this.item, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline
          Column(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item.color.withValues(alpha: 0.12),
                ),
                child: Center(child: Text(item.icon,
                  style: const TextStyle(fontSize: 15))),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2, color: AdminColors.mintTint.withValues(alpha: 0.2),
                    margin: const EdgeInsets.symmetric(vertical: 2)),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.title,
                        style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600,
                          color: AdminColors.white)),
                      Text(item.time,
                        style: const TextStyle(
                          fontSize: 11, color: AdminColors.mutedSageGrey)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(item.subtitle,
                    style: const TextStyle(
                      fontSize: 12, color: AdminColors.mutedSageGrey)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// AUDIT LOG PREVIEW
// =============================================================================
class _AuditLogPreview extends StatelessWidget {
  const _AuditLogPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AdminColors.secondaryDark,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                const Text('🔍', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Text('Audit Log',
                  style: AppTheme.headingMedium.copyWith(
                    color: AdminColors.white, fontSize: 18)),
              ]),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: AdminColors.accentYellow,
                  textStyle: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600)),
                child: const Text('View All →'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...MockData.audits.map((a) => _AuditTile(entry: a)),
        ],
      ),
    );
  }
}

class _AuditTile extends StatelessWidget {
  final AuditEntry entry;
  const _AuditTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AdminColors.primaryDark.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AdminColors.primaryDark, AdminColors.mediumGreen]),
            ),
            child: Center(
              child: Text(entry.admin.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  color: AdminColors.accentYellow,
                  fontSize: 14, fontWeight: FontWeight.w800)),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.admin,
                      style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700,
                        color: AdminColors.white)),
                    Text(entry.time,
                      style: const TextStyle(
                        fontSize: 10, color: AdminColors.mutedSageGrey)),
                  ],
                ),
                const SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 11, color: AdminColors.mutedSageGrey),
                    children: [
                      TextSpan(text: entry.action),
                      const TextSpan(text: ' → '),
                      TextSpan(
                        text: entry.target,
                        style: const TextStyle(
                          color: AdminColors.accentYellow,
                          fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
