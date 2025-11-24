import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homeworkout/models/workoutplan_model.dart';

class WorkoutPlanService{
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<WorkoutPlan>> getWorkoutPlans() async {
    final snap = await _db.collection("workout_plan").get();

    return snap.docs.map((doc) {
      return WorkoutPlan.fromMap(doc.id, doc.data());
    }).toList();
  }
}