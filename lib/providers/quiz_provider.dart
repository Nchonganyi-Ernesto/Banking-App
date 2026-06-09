import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quiz_question_model.dart';
import '../data/saving_strategies_quiz_data.dart';

// Quiz state to track progress
class QuizState {
  final List<QuizQuestion> questions;
  final int currentQuestionIndex;
  final int score;
  final List<int?> userAnswers;
  final bool isCompleted;

  QuizState({
    required this.questions,
    this.currentQuestionIndex = 0,
    this.score = 0,
    List<int?>? userAnswers,
    this.isCompleted = false,
  }) : userAnswers = userAnswers ?? List.filled(questions.length, null);

  QuizState copyWith({
    List<QuizQuestion>? questions,
    int? currentQuestionIndex,
    int? score,
    List<int?>? userAnswers,
    bool? isCompleted,
  }) {
    return QuizState(
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      score: score ?? this.score,
      userAnswers: userAnswers ?? this.userAnswers,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  int get totalQuestions => questions.length;
  int get answeredQuestions => userAnswers.where((a) => a != null).length;
  double get progress => totalQuestions > 0 ? answeredQuestions / totalQuestions : 0.0;
}

// Quiz notifier to manage quiz state
class QuizNotifier extends Notifier<QuizState> {
  @override
  QuizState build() {
    return QuizState(
      questions: savingStrategiesQuiz,
    );
  }

  void answerQuestion(int answerIndex) {
    final question = state.questions[state.currentQuestionIndex];
    final isCorrect = answerIndex == question.correctAnswerIndex;
    
    // Update user answers
    final updatedAnswers = List<int?>.from(state.userAnswers);
    updatedAnswers[state.currentQuestionIndex] = answerIndex;

    // Update score if correct
    final newScore = isCorrect ? state.score + question.points : state.score;

    state = state.copyWith(
      userAnswers: updatedAnswers,
      score: newScore,
    );
  }

  void nextQuestion() {
    if (state.currentQuestionIndex < state.questions.length - 1) {
      state = state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex + 1,
      );
    } else {
      state = state.copyWith(isCompleted: true);
    }
  }

  void previousQuestion() {
    if (state.currentQuestionIndex > 0) {
      state = state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex - 1,
      );
    }
  }

  void resetQuiz() {
    state = QuizState(questions: savingStrategiesQuiz);
  }
}

// Provider for quiz state
final quizProvider = NotifierProvider<QuizNotifier, QuizState>(() {
  return QuizNotifier();
});
