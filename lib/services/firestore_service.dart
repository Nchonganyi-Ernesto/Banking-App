import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get usersRef => _db.collection('users');
  CollectionReference<Map<String, dynamic>> get transactionsRef => _db.collection('transactions');

  // Create new user document with zero balance
  Future<void> createUserDocument(String uid, String name) async {
    await usersRef.doc(uid).set({
      'name': name,
      'avatarUrl': '',
      'balance': 0.0,
      'available': 0.0,
      'sparklineData': [30, 70, 50, 90, 60, 80, 100, 75],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Get user data (one-time fetch)
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData(String uid) {
    return usersRef.doc(uid).get();
  }

  // Stream user data (real-time updates)
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUserData(String uid) {
    return usersRef.doc(uid).snapshots();
  }

  // Update user data
  Future<void> setUserData(String uid, Map<String, dynamic> data) {
    data['updatedAt'] = FieldValue.serverTimestamp();
    return usersRef.doc(uid).set(data, SetOptions(merge: true));
  }

  // Update user balance
  Future<void> updateUserBalance(String uid, double balance, double available) async {
    await usersRef.doc(uid).update({
      'balance': balance,
      'available': available,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Stream user transactions
  Stream<QuerySnapshot<Map<String, dynamic>>> streamUserTransactions(String uid) {
    return transactionsRef.where('userId', isEqualTo: uid).snapshots();
  }
}
