import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Sign in anonymously
  Future<User?> signInAnonymously() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      final user = userCredential.user;

      if (user != null) {
        await _createUserDocumentIfNotExists(user.uid);
      }

      print("Anonymous login: ${user?.uid}");
      return user;
    } catch (e) {
      print("Anonymous login error: $e");
      return null;
    }
  }

  // Create user document in Firestore if not exists
  Future<void> _createUserDocumentIfNotExists(String uid) async {
    final docRef = _db.collection('users').doc(uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set({
        'createdAt': Timestamp.now(),
        'isAnonymous': true,
        'lastLogin': Timestamp.now(),
      });
    } else {
      await docRef.update({
        'lastLogin': Timestamp.now(),
      });
    }
  }

  User? get currentUser => _auth.currentUser;
}
