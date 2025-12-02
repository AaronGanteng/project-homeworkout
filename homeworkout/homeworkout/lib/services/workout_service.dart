import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homeworkout/models/workout_model.dart';

class WorkoutService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Pastikan nama collection sesuai database Anda.
  // Di kode error Anda tertulis "data_workout", pastikan itu benar.
  final String _collectionName = "data_workout";

  /// Get All Workouts (Live)
  Stream<List<Workout>> getWorkouts() {
    return _db.collection(_collectionName).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // PERBAIKAN UTAMA DISINI:
        // Gunakan .fromSnapshot(doc) sesuai Model yang kita buat.
        // Tidak perlu memisah doc.data() manual.
        return Workout.fromSnapshot(doc);
      }).toList();
    });
  }

  /// Get Workouts by BodyPart
  Stream<List<Workout>> getWorkoutsByBodyParts(List<String> bodyParts) {
    if (bodyParts.isEmpty) {
      return getWorkouts();
    }

    return _db
        .collection(_collectionName)
        .where("bodyParts", arrayContainsAny: bodyParts)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        // PERBAIKAN:
        return Workout.fromSnapshot(doc);
      }).toList();
    });
  }

  /// One-time Get (not stream)
  Future<List<Workout>> fetchWorkoutsOnce() async {
    final snap = await _db.collection(_collectionName).get();

    return snap.docs.map((doc) {
      // PERBAIKAN:
      return Workout.fromSnapshot(doc);
    }).toList();
  }

  /// Search Workouts
  Stream<List<Workout>> searchWorkouts(String query) {
    if (query.isEmpty) {
      return getWorkouts();
    }

    return _db
        .collection(_collectionName)
        .where("keywords", arrayContains: query.toLowerCase())
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        // PERBAIKAN:
        return Workout.fromSnapshot(doc);
      }).toList();
    });
  }
}