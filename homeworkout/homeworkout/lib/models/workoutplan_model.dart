class WorkoutPlan {
  final String id;
  final String name;
  final String level;
  final int duration;
  final String bodyPart;
  final List<dynamic> exercises;
  final String imageUrl; // Biar sama seperti mock

  WorkoutPlan({
    required this.id,
    required this.name,
    required this.level,
    required this.duration,
    required this.bodyPart,
    required this.exercises,
    required this.imageUrl,
  });

  factory WorkoutPlan.fromMap(String id, Map<String, dynamic> data) {
    return WorkoutPlan(
      id: id,
      name: data['name'] ?? '',
      level: data['level'] ?? '',
      duration: data['duration'] ?? 0,
      bodyPart: data['bodyPart'] ?? '',
      exercises: data['exercises'] ?? [],
      imageUrl: data['imageUrl'] ??
          'https://placehold.co/300x220/111111/FFFFFF?text=${data['name']}',
    );
  }
}
