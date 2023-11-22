import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppService {
  AppService(FirebaseAuth instance);

  get authStateChanges => null;

  Future<String?> getLatestUnfinishedTestId() async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Tests')
          .where('testFinished', isEqualTo: false)
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot latestTest = querySnapshot.docs.first;
        return latestTest.id;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }
}
