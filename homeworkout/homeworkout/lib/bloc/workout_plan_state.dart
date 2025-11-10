part of 'workout_plan_bloc.dart';

@immutable
abstract class WorkoutPlanState {}

class WorkoutPlanInitial extends WorkoutPlanState {}

class PlansLoading extends WorkoutPlanState {}

class PlansLoaded extends WorkoutPlanState {
  // Anda bisa memasukkan data latihannya di sini
  // final List<WorkoutPlan> plans;
  // PlansLoaded(this.plans);
}
class PlansError extends WorkoutPlanState {
  final String message;
  PlansError(this.message);
}
