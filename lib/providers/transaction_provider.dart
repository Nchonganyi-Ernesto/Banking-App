import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction_model.dart';

// We use a simple Provider (not StateNotifier) here because the transaction
// list doesn't change during this session — it's read-only dummy data.
// If we needed to add/remove transactions, we'd upgrade to StateNotifier.

final transactionProvider = Provider<List<TransactionModel>>((ref) {
  return const [
    TransactionModel(
      name: 'Dribble',
      iconPath: 'dribble',      // We'll map these to Icons in the widget
      date: '2 Jun 2024, 12:10 PM',
      amount: 1220.00,
      isReceived: true,         // Green — money came in
    ),
    TransactionModel(
      name: 'iPhone 16',
      iconPath: 'apple',
      date: '2 Jun 2024, 12:10 PM',
      amount: 1420.00,
      isReceived: false,        // Red — money went out
    ),
    TransactionModel(
      name: 'Amazon',
      iconPath: 'amazon',
      date: '2 Jun 2024, 12:10 PM',
      amount: 1720.00,
      isReceived: false,
    ),
    TransactionModel(
      name: 'Salary',
      iconPath: 'work',
      date: '1 Jun 2024, 09:00 AM',
      amount: 5000.00,
      isReceived: true,
    ),
    TransactionModel(
      name: 'Netflix',
      iconPath: 'movie',
      date: '31 May 2024, 06:30 PM',
      amount: 15.99,
      isReceived: false,
    ),
  ];
});
