import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction_model.dart';

// We use a simple Provider (not StateNotifier) here because the transaction
// list doesn't change during this session — it's read-only dummy data.
// If we needed to add/remove transactions, we'd upgrade to StateNotifier.

final transactionProvider = Provider<List<TransactionModel>>((ref) {
  return const [
    TransactionModel(
      name: 'Restaurant',
      iconPath: 'restaurant',
      date: '6 Jun 2026, 12:10 PM',
      amount: 1220.00,
      isReceived: false,        // Red — money spent
    ),
    TransactionModel(
      name: 'iPhone 16',
      iconPath: 'apple',
      date: '6 Jun 2026, 12:10 PM',
      amount: 1420.00,
      isReceived: false,        // Red — money went out
    ),
    TransactionModel(
      name: 'Amazon',
      iconPath: 'amazon',
      date: '6 Jun 2026, 12:10 PM',
      amount: 1720.00,
      isReceived: false,
    ),
    TransactionModel(
      name: 'Salary',
      iconPath: 'work',
      date: '6 Jun 2026, 09:00 AM',
      amount: 5000.00,
      isReceived: true,
    ),
    TransactionModel(
      name: 'Netflix',
      iconPath: 'movie',
      date: '5 Jun 2026, 06:30 PM',
      amount: 15.99,
      isReceived: false,
    ),
  ];
});
