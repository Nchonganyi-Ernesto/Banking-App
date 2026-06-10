// A Model is a plain Dart class that represents a piece of data.
// It has NO UI code — just data fields and helper methods.
// This makes it easy to swap the data source (e.g. from dummy data to a real API)
// without touching any widget.

class UserModel {
  final String name;          // e.g. "Tamon Joel"
  final String avatarUrl;     // URL or asset path for profile picture
  final double balance;       // e.g. 4250.34
  final double available;     // e.g. 5748.88 (credit available)
  final List<double> sparklineData; // Points for the mini chart on the card

  const UserModel({
    required this.name,
    required this.avatarUrl,
    required this.balance,
    required this.available,
    required this.sparklineData,
  });

  // Convert Firestore document to UserModel
  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      name: data['name'] ?? 'User',
      avatarUrl: data['avatarUrl'] ?? '',
      balance: (data['balance'] ?? 0.0).toDouble(),
      available: (data['available'] ?? 0.0).toDouble(),
      sparklineData: data['sparklineData'] != null
          ? List<double>.from(data['sparklineData'])
          : [30, 70, 50, 90, 60, 80, 100, 75], // Default sparkline
    );
  }

  // Convert UserModel to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'avatarUrl': avatarUrl,
      'balance': balance,
      'available': available,
      'sparklineData': sparklineData,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  // Create a copy with updated fields
  UserModel copyWith({
    String? name,
    String? avatarUrl,
    double? balance,
    double? available,
    List<double>? sparklineData,
  }) {
    return UserModel(
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      balance: balance ?? this.balance,
      available: available ?? this.available,
      sparklineData: sparklineData ?? this.sparklineData,
    );
  }
}
