class Workout {
  final String id;
  final String name;
  final String imageUrl;
  final List<String> bodyParts;
  final List<String> keywords;
  final List<String> equipment;
  final List<String> targetMuscles;
  final List<String> secondaryMuscles;


  Workout({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.bodyParts,
    required this.keywords,
    required this.equipment,
    required this.targetMuscles,
    required this.secondaryMuscles,
  });

  factory Workout.fromMap(String id, Map<String, dynamic> data) {
    final bodyPartsFromData = data['bodyParts'] as List<dynamic>?;
    return Workout(
      id: id,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      bodyParts: bodyPartsFromData?.map((part) => part.toString().toUpperCase()).toList() ?? [],
      keywords: data['keywords']?.cast<String>() ?? [],
      equipment: data['equipment']?.cast<String>() ?? [],
      targetMuscles: data['targetMuscles']?.cast<String>() ?? [],
      secondaryMuscles: data['secondaryMuscles']?.cast<String>() ?? [],
    );
  }
}
