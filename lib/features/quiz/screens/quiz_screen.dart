import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/quiz_provider.dart';
import 'quiz_results_screen.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen>
    with TickerProviderStateMixin {
  int? selectedAnswer;
  bool showExplanation = false;
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Slide animation for question cards
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Fade animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _slideController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _animateTransition() {
    _slideController.reset();
    _fadeController.reset();
    _slideController.forward();
    _fadeController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizProvider);
    final quizNotifier = ref.read(quizProvider.notifier);

    // Navigate to results when quiz is completed
    if (quizState.isCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const QuizResultsScreen(),
          ),
        );
      });
    }

    final currentQuestion = quizState.questions[quizState.currentQuestionIndex];
    final questionNumber = quizState.currentQuestionIndex + 1;

    return Scaffold(
      backgroundColor: AppTheme.pageBg,
      appBar: AppBar(
        backgroundColor: AppTheme.cardGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () => _showExitDialog(context, quizNotifier),
        ),
        title: Text(
          'Saving Strategies Quiz',
          style: AppTheme.headingMedium.copyWith(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar
            _buildProgressBar(quizState),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Question counter
                        Text(
                          'Question $questionNumber of ${quizState.totalQuestions}',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.actionYellow,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Question card
                        _buildQuestionCard(currentQuestion.question),
                        const SizedBox(height: 24),

                        // Answer options
                        ...currentQuestion.options.asMap().entries.map((entry) {
                          final index = entry.key;
                          final option = entry.value;
                          return _buildOptionCard(
                            index,
                            option,
                            currentQuestion.correctAnswerIndex,
                          );
                        }),

                        // Explanation (shown after answer)
                        if (showExplanation) ...[
                          const SizedBox(height: 20),
                          _buildExplanationCard(currentQuestion.explanation),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bottom button
            _buildBottomButton(quizNotifier),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(QuizState quizState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      color: AppTheme.cardGreen,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${quizState.currentQuestionIndex + 1}/${quizState.totalQuestions}',
                style: AppTheme.bodySmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${quizState.score} pts',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.actionYellow,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (quizState.currentQuestionIndex + 1) / quizState.totalQuestions,
              backgroundColor: AppTheme.mediumGreen,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.actionYellow),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(String question) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardGreen,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        question,
        style: AppTheme.headingMedium.copyWith(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildOptionCard(int index, String option, int correctIndex) {
    final isSelected = selectedAnswer == index;
    final isCorrect = index == correctIndex;
    final showResult = showExplanation;

    Color backgroundColor = AppTheme.darkGreen;
    Color borderColor = AppTheme.mediumGreen;
    Color textColor = Colors.white;

    if (showResult) {
      if (isCorrect) {
        backgroundColor = AppTheme.receivedGreen.withValues(alpha: 0.15);
        borderColor = AppTheme.receivedGreen;
      } else if (isSelected && !isCorrect) {
        backgroundColor = AppTheme.sentRed.withValues(alpha: 0.15);
        borderColor = AppTheme.sentRed;
      }
    } else if (isSelected) {
      borderColor = AppTheme.actionYellow;
    }

    return GestureDetector(
      onTap: showExplanation ? null : () => _selectAnswer(index),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected || (showResult && isCorrect)
                    ? (showResult && isCorrect
                        ? AppTheme.receivedGreen
                        : AppTheme.actionYellow)
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected || (showResult && isCorrect)
                      ? Colors.transparent
                      : AppTheme.textMuted,
                  width: 2,
                ),
              ),
              child: showResult && isCorrect
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                option,
                style: AppTheme.bodyMedium.copyWith(
                  color: textColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExplanationCard(String explanation) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.actionYellow.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.actionYellow.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            color: AppTheme.actionYellow,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              explanation,
              style: AppTheme.bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(QuizNotifier quizNotifier) {
    final buttonText = showExplanation ? 'Next Question' : 'Submit Answer';
    final isEnabled = selectedAnswer != null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardGreen,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isEnabled
            ? () {
                if (showExplanation) {
                  // Move to next question
                  quizNotifier.nextQuestion();
                  setState(() {
                    selectedAnswer = null;
                    showExplanation = false;
                  });
                  _animateTransition();
                } else {
                  // Show explanation
                  if (selectedAnswer != null) {
                    quizNotifier.answerQuestion(selectedAnswer!);
                    setState(() => showExplanation = true);
                  }
                }
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? AppTheme.actionYellow : AppTheme.mediumGreen,
          foregroundColor: AppTheme.textDark,
          minimumSize: const Size(double.infinity, 54),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          buttonText,
          style: AppTheme.labelBold.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  void _selectAnswer(int index) {
    setState(() => selectedAnswer = index);
  }

  void _showExitDialog(BuildContext context, QuizNotifier quizNotifier) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardGreen,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Exit Quiz?',
          style: AppTheme.headingMedium.copyWith(color: Colors.white),
        ),
        content: Text(
          'Your progress will be lost if you exit now.',
          style: AppTheme.bodyMedium.copyWith(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: AppTheme.labelBold.copyWith(color: AppTheme.actionYellow),
            ),
          ),
          TextButton(
            onPressed: () {
              quizNotifier.resetQuiz();
              Navigator.pop(ctx); // Close dialog
              Navigator.pop(context); // Go back to dashboard
            },
            child: Text(
              'Exit',
              style: AppTheme.labelBold.copyWith(color: AppTheme.sentRed),
            ),
          ),
        ],
      ),
    );
  }
}
