import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get usersRef => _db.collection('users');
  CollectionReference<Map<String, dynamic>> get transactionsRef => _db.collection('transactions');

  Future<void> setUserData(String uid, Map<String, dynamic> data) {
    return usersRef.doc(uid).set(data, SetOptions(merge: true));
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData(String uid) {
    return usersRef.doc(uid).get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamUserTransactions(String uid) {
    return transactionsRef.where('userId', isEqualTo: uid).snapshots();
  }
}
