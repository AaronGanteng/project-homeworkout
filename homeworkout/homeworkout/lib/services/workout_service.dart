import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homeworkout/models/workout_model.dart';

class WorkoutService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Get All Workouts (Live)
  Stream<List<Workout>> getWorkouts() {
    return _db.collection("data_workout").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Workout.fromMap(doc.id, data);
      }).toList();
    });
  }

  /// Get Workouts by BodyPart (Optional)
  Stream<List<Workout>> getWorkoutsByBodyParts(List<String> bodyParts) {
    if (bodyParts.isEmpty) {
      return getWorkouts();
    }

    return _db
        .collection("data_workout")
        .where("bodyParts", arrayContainsAny: bodyParts)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Workout.fromMap(doc.id, data);
      }).toList();
    });
  }

  /// One-time Get (not stream)
  Future<List<Workout>> fetchWorkoutsOnce() async {
    final snap = await _db.collection("data_workout").get();

    return snap.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Workout.fromMap(doc.id, data);
    }).toList();
  }

  Stream<List<Workout>> searchWorkouts(String query) {
    if (query.isEmpty) {
      return getWorkouts();
    }

    return _db
        .collection("data_workout")
        .where("keywords", arrayContains: query.toLowerCase())
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Workout.fromMap(doc.id, data);
      }).toList();
    });
  }

}
