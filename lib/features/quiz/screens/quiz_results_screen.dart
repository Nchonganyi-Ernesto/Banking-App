import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/quiz_provider.dart';
import '../../../providers/user_provider.dart';
import 'quiz_screen.dart';

class QuizResultsScreen extends ConsumerStatefulWidget {
  const QuizResultsScreen({super.key});

  @override
  ConsumerState<QuizResultsScreen> createState() => _QuizResultsScreenState();
}

class _QuizResultsScreenState extends ConsumerState<QuizResultsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late ConfettiController _confettiController;
  bool _isClaimed = false;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    _controller.forward();
    
    // Trigger confetti after a short delay
    Future.delayed(const Duration(milliseconds: 400), () {
      _confettiController.play();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizProvider);
    final quizNotifier = ref.read(quizProvider.notifier);
    
    final totalQuestions = quizState.totalQuestions;
    final correctAnswers = _calculateCorrectAnswers(quizState);
    final percentage = (correctAnswers / totalQuestions * 100).round();
    final reward = _calculateReward(quizState.score);

    return Scaffold(
      backgroundColor: AppTheme.pageBg,
      appBar: AppBar(
        backgroundColor: AppTheme.cardGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Quiz Results',
          style: AppTheme.headingMedium.copyWith(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Score card with animation
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: _buildScoreCard(
                        correctAnswers,
                        totalQuestions,
                        percentage,
                        quizState.score,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Reward card
                    _buildRewardCard(reward),

                    const SizedBox(height: 24),

                    // Performance message
                    _buildPerformanceMessage(percentage),

                    const SizedBox(height: 32),

                    // Action buttons
                    _buildActionButtons(quizNotifier, reward),
                  ],
                ),
              ),
            ),
          ),

          // Confetti overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: 3.14 / 2, // Down
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.3,
              colors: [
                AppTheme.actionYellow,
                AppTheme.receivedGreen,
                AppTheme.accentGreen,
                Colors.white,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(
    int correct,
    int total,
    int percentage,
    int points,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppTheme.cardGreen,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Trophy/Star icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.actionYellow,
              shape: BoxShape.circle,
            ),
            child: Icon(
              percentage >= 70 ? Icons.emoji_events_rounded : Icons.star_rounded,
              size: 40,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 20),

          // Score text
          Text(
            '$correct / $total',
            style: AppTheme.headingLarge.copyWith(
              color: AppTheme.actionYellow,
              fontSize: 48,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Questions Correct',
            style: AppTheme.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 20),

          // Percentage circle
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: percentage >= 70
                  ? AppTheme.receivedGreen.withValues(alpha: 0.2)
                  : AppTheme.actionYellow.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$percentage%',
              style: AppTheme.headingMedium.copyWith(
                color: percentage >= 70 ? AppTheme.receivedGreen : AppTheme.actionYellow,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Points earned
          Text(
            '$points Points',
            style: AppTheme.bodyMedium.copyWith(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardCard(int reward) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.receivedGreen,
            AppTheme.receivedGreen.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.receivedGreen.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.stars_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Points Earned',
                  style: AppTheme.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$reward Points',
                  style: AppTheme.headingLarge.copyWith(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.check_circle_rounded,
            color: Colors.white,
            size: 32,
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMessage(int percentage) {
    String message;
    IconData icon;
    Color color;

    if (percentage >= 90) {
      message = 'Outstanding! You\'re a saving strategies expert! 🎉';
      icon = Icons.emoji_events_rounded;
      color = AppTheme.receivedGreen;
    } else if (percentage >= 70) {
      message = 'Great job! You have solid knowledge of saving strategies! 👏';
      icon = Icons.thumb_up_rounded;
      color = AppTheme.actionYellow;
    } else if (percentage >= 50) {
      message = 'Good effort! Keep learning about saving strategies! 💪';
      icon = Icons.trending_up_rounded;
      color = AppTheme.actionYellow;
    } else {
      message = 'Keep practicing! Every quiz helps you learn more! 📚';
      icon = Icons.school_rounded;
      color = AppTheme.textMuted;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkGreen,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: AppTheme.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(QuizNotifier quizNotifier, int reward) {
    return Column(
      children: [
        // Claim reward button
        ElevatedButton(
          onPressed: _isClaimed ? null : () => _claimReward(reward),
          style: ElevatedButton.styleFrom(
            backgroundColor: _isClaimed ? AppTheme.mediumGreen : AppTheme.actionYellow,
            foregroundColor: _isClaimed ? Colors.white : AppTheme.textDark,
            minimumSize: const Size(double.infinity, 54),
            elevation: 0,
            disabledBackgroundColor: AppTheme.mediumGreen,
            disabledForegroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            _isClaimed ? 'Claimed' : 'Claim Points',
            style: AppTheme.labelBold.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Retake quiz button
        OutlinedButton(
          onPressed: () {
            quizNotifier.resetQuiz();
            // Pop results screen and push new quiz screen
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const QuizScreen()),
            );
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 54),
            side: BorderSide(color: AppTheme.mediumGreen, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            'Retake Quiz',
            style: AppTheme.labelBold.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Back to dashboard
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: Text(
            'Back to Dashboard',
            style: AppTheme.labelBold.copyWith(
              color: AppTheme.textMuted,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  int _calculateCorrectAnswers(QuizState quizState) {
    int correct = 0;
    for (int i = 0; i < quizState.questions.length; i++) {
      if (quizState.userAnswers[i] == quizState.questions[i].correctAnswerIndex) {
        correct++;
      }
    }
    return correct;
  }

  int _calculateReward(int points) {
    // Return points as reward
    return points;
  }

  void _claimReward(int reward) async {
    setState(() {
      _isClaimed = true;
    });

    // Add points to user balance in Firestore
    try {
      final userActions = ref.read(userActionsProvider);
      await userActions.addBalance(reward.toDouble());

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 $reward Points Added to Balance!'),
            backgroundColor: AppTheme.receivedGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // If error, show error message and reset claimed state
      if (mounted) {
        setState(() {
          _isClaimed = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to claim points. Try again.'),
            backgroundColor: AppTheme.sentRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
