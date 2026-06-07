// TransactionModel holds all data for a single transaction row.
// Notice the 'isReceived' boolean — we use it to decide the color:
//   true  → green text  (money came IN)
//   false → red text    (money went OUT)
// This logic lives in the model, not the widget, keeping the widget clean.

class TransactionModel {
  final String name;        // e.g. "Dribble", "iPhone 16"
  final String iconPath;    // Asset path for the company/contact logo
  final String date;        // e.g. "2 Jun 2024, 12:10 PM"
  final double amount;      // e.g. 1220.00
  final bool isReceived;    // true = received (green), false = sent (red)

  const TransactionModel({
    required this.name,
    required this.iconPath,
    required this.date,
    required this.amount,
    required this.isReceived,
  });
}
