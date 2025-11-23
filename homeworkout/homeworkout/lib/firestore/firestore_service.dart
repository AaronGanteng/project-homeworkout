import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // Get a reference to the Cloud Firestore instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- User Management Functions ---

  /// Creates or updates a user's profile in the 'users' collection.
  Future<void> setUser(String userId, Map<String, dynamic> userData) {
    return _db.collection('users').doc(userId).set(userData, SetOptions(merge: true));
  }

  /// Retrieves a specific user's document from Firestore.
  Future<DocumentSnapshot> getUser(String userId) {
    return _db.collection('users').doc(userId).get();
  }

  // --- Workout Management Functions ---

  /// Retrieves a stream of all workout plans from the 'workouts' collection.
  Stream<QuerySnapshot> getWorkouts() {
    return _db.collection('workouts').snapshots();
  }

  /// Retrieves a specific workout document.
  Future<DocumentSnapshot> getWorkoutById(String workoutId) {
    return _db.collection('workouts').doc(workoutId).get();
  }

  // --- Exercise Management Functions ---

  /// Retrieves all exercises for a specific workout plan.
  Stream<QuerySnapshot> getExercisesForWorkout(String workoutId) {
    return _db.collection('workouts').doc(workoutId).collection('exercises').orderBy('order').snapshots();
  }

  // --- User Progress Functions ---

  /// Logs a completed workout for a user.
  Future<void> logWorkoutCompletion(String userId, String workoutId, Map<String, dynamic> completionData) {
    // Example completionData: {'date': Timestamp.now(), 'durationInMinutes': 30}
    return _db.collection('users').doc(userId).collection('completedWorkouts').add({
      'workoutId': workoutId,
      ...completionData,
    });
  }

  /// Retrieves the workout history for a specific user.
  Stream<QuerySnapshot> getUserWorkoutHistory(String userId) {
    return _db.collection('users').doc(userId).collection('completedWorkouts').orderBy('date', descending: true).snapshots();
  }
}
