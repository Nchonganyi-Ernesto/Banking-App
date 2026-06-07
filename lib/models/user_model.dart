// A Model is a plain Dart class that represents a piece of data.
// It has NO UI code — just data fields and helper methods.
// This makes it easy to swap the data source (e.g. from dummy data to a real API)
// without touching any widget.

class UserModel {
  final String name;          // e.g. "Tamon Joel"
  final String avatarUrl;     // URL or asset path for profile picture
  final double balance;       // e.g. 4250.34
  final double available;     // e.g. 5748.88 (credit available)
  final double due;           // e.g. 1024.00 (amount owed)
  final List<double> sparklineData; // Points for the mini chart on the card

  const UserModel({
    required this.name,
    required this.avatarUrl,
    required this.balance,
    required this.available,
    required this.due,
    required this.sparklineData,
  });
}
