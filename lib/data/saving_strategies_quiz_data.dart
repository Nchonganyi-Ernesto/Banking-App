import '../models/quiz_question_model.dart';

// Saving Strategies Quiz Data
// This contains practical questions about saving money effectively

final List<QuizQuestion> savingStrategiesQuiz = [
  QuizQuestion(
    question: 'What is the 50/30/20 budgeting rule?',
    options: [
      '50% wants, 30% needs, 20% savings',
      '50% needs, 30% wants, 20% savings',
      '50% savings, 30% needs, 20% wants',
      '50% needs, 30% savings, 20% wants',
    ],
    correctAnswerIndex: 1,
    explanation: 'The 50/30/20 rule allocates 50% of income to needs, 30% to wants, and 20% to savings and debt repayment.',
    points: 100,
  ),
  QuizQuestion(
    question: 'What is an emergency fund used for?',
    options: [
      'Vacation and entertainment expenses',
      'Unexpected expenses like medical bills or job loss',
      'Investing in the stock market',
      'Buying luxury items on sale',
    ],
    correctAnswerIndex: 1,
    explanation: 'An emergency fund is savings set aside for unexpected expenses like medical emergencies, car repairs, or income loss.',
    points: 100,
  ),
  QuizQuestion(
    question: 'How many months of expenses should an emergency fund ideally cover?',
    options: [
      '1-2 months',
      '3-6 months',
      '9-12 months',
      '2 years',
    ],
    correctAnswerIndex: 1,
    explanation: 'Financial experts recommend saving 3-6 months of living expenses in an emergency fund for financial security.',
    points: 100,
  ),
  QuizQuestion(
    question: 'Which saving method involves paying yourself first?',
    options: [
      'Save whatever is left at the end of the month',
      'Set aside savings before spending on anything else',
      'Only save when you have extra money',
      'Save only during bonus months',
    ],
    correctAnswerIndex: 1,
    explanation: '"Pay yourself first" means setting aside savings immediately when you receive income, before any other expenses.',
    points: 100,
  ),
  QuizQuestion(
    question: 'What is the benefit of automating your savings?',
    options: [
      'You earn higher interest rates',
      'It removes the temptation to spend',
      'Banks give you bonus rewards',
      'You can withdraw anytime without penalty',
    ],
    correctAnswerIndex: 1,
    explanation: 'Automating savings removes the temptation to spend that money and ensures consistent saving habits.',
    points: 100,
  ),
  QuizQuestion(
    question: 'What is a "sinking fund"?',
    options: [
      'Money saved for expected future expenses',
      'A fund that loses value over time',
      'Emergency savings only',
      'Retirement savings account',
    ],
    correctAnswerIndex: 0,
    explanation: 'A sinking fund is money saved gradually for planned future expenses like holidays, car maintenance, or annual fees.',
    points: 100,
  ),
  QuizQuestion(
    question: 'Which strategy helps reduce impulse spending?',
    options: [
      'Buy now, think later',
      'Use the 24-hour rule before purchases',
      'Always shop when stressed',
      'Keep all credit cards in your wallet',
    ],
    correctAnswerIndex: 1,
    explanation: 'The 24-hour rule means waiting a day before making non-essential purchases, which often reduces impulse buying.',
    points: 100,
  ),
  QuizQuestion(
    question: 'What percentage of income do experts recommend saving?',
    options: [
      '5% or less',
      'At least 20%',
      '50% or more',
      'Whatever is left over',
    ],
    correctAnswerIndex: 1,
    explanation: 'Financial experts typically recommend saving at least 20% of your income for future goals and emergencies.',
    points: 100,
  ),
  QuizQuestion(
    question: 'What is the "latte factor"?',
    options: [
      'Coffee improves productivity',
      'Small daily expenses that add up over time',
      'A type of investment strategy',
      'A budgeting app',
    ],
    correctAnswerIndex: 1,
    explanation: 'The "latte factor" refers to small recurring expenses (like daily coffee) that seem minor but accumulate significantly.',
    points: 100,
  ),
  QuizQuestion(
    question: 'When is the best time to start saving?',
    options: [
      'When you earn a high salary',
      'After buying a house',
      'As soon as possible, no matter the amount',
      'Only after age 30',
    ],
    correctAnswerIndex: 2,
    explanation: 'The best time to start saving is now, regardless of the amount. Small savings grow through consistency and compound interest.',
    points: 100,
  ),
];
