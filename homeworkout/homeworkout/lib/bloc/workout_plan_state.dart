part of 'workout_plan_bloc.dart';

@immutable
abstract class WorkoutPlanState {}

class WorkoutPlanInitial extends WorkoutPlanState {}

class PlansLoading extends WorkoutPlanState {}

class PlansLoaded extends WorkoutPlanState {
  final List<dynamic> plans;
  PlansLoaded(this.plans);
}
class PlansError extends WorkoutPlanState {
  final String message;
  PlansError(this.message);
}
