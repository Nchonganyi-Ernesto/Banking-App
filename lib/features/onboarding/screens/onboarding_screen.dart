import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../auth/screens/login_screen.dart';

// Simple in-memory storage for onboarding status
// Set to true to skip onboarding during development
bool _hasSeenOnboarding = true;

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
  
  // Static method to check if onboarding has been completed
  static bool isCompleted() {
    return _hasSeenOnboarding;
  }
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isNavigating = false;

  final List<OnboardingData> _onboardingPages = [
    OnboardingData(
      title: 'Secure Banking',
      description: 'Your money is safe with advanced encryption and security features',
      icon: Icons.security_rounded,
      color: AppTheme.actionYellow,
    ),
    OnboardingData(
      title: 'Instant Transfers',
      description: 'Send and receive money instantly with zero fees',
      icon: Icons.send_rounded,
      color: AppTheme.accentGreen,
    ),
    OnboardingData(
      title: 'Smart Analytics',
      description: 'Track your spending and get insights to save more',
      icon: Icons.analytics_rounded,
      color: AppTheme.actionYellow,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.pageBg,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 1.5,
                colors: [
                  AppTheme.darkGreen.withValues(alpha: 0.4),
                  AppTheme.pageBg,
                  AppTheme.pageBg,
                ],
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemCount: _onboardingPages.length,
                  itemBuilder: (context, index) {
                    return OnboardingPage(
                      data: _onboardingPages[index],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _onboardingPages.length,
                        (index) => _buildDot(index),
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (_currentPage == _onboardingPages.length - 1)
                      _buildGetStartedButton()
                    else
                      _buildNextButton(),
                    const SizedBox(height: 16),
                    if (_currentPage != _onboardingPages.length - 1)
                      TextButton(
                        onPressed: _isNavigating ? null : () => _completeOnboarding(),
                        child: Text(
                          'Skip',
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      width: _currentPage == index ? 32 : 8,
      height: 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: _currentPage == index
            ? AppTheme.actionYellow
            : AppTheme.textMuted.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildNextButton() {
    return Container(
      height: 56,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.darkGreen,
            AppTheme.mediumGreen,
          ],
        ),
        border: Border.all(color: AppTheme.textMuted.withValues(alpha: 0.2)),
      ),
      child: ElevatedButton(
        onPressed: _isNavigating ? null : () {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Next',
              style: AppTheme.labelBold.copyWith(
                color: AppTheme.textLight,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_rounded, color: AppTheme.textLight, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildGetStartedButton() {
    return Container(
      height: 56,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.actionYellow,
            AppTheme.accentGreen,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.actionYellow.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: -5,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isNavigating ? null : _completeOnboarding,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: _isNavigating
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.textDark),
                ),
              )
            : Text(
                'Get Started',
                style: AppTheme.labelBold.copyWith(
                  color: AppTheme.textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }

  void _completeOnboarding() {
    if (_isNavigating) return;
    
    setState(() {
      _isNavigating = true;
    });
    
    // Set the flag to true
    _hasSeenOnboarding = true;
    
    // Navigate to login screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  data.color.withValues(alpha: 0.2),
                  data.color.withValues(alpha: 0.05),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    data.color,
                    data.color.withValues(alpha: 0.7),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: data.color.withValues(alpha: 0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                data.icon,
                size: 60,
                color: AppTheme.darkGreen,
              ),
            ),
          ),
          const SizedBox(height: 48),
          Text(
            data.title,
            style: AppTheme.headingLarge.copyWith(
              fontSize: 32,
              color: AppTheme.textLight,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            data.description,
            style: AppTheme.bodyMedium.copyWith(
              fontSize: 16,
              color: AppTheme.textMuted,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}