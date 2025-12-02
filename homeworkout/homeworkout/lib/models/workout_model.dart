import 'package:cloud_firestore/cloud_firestore.dart';

class Workout {
  final String id;
  final String name;
  final String imageUrl;
  final List<String> bodyParts;
  final List<String> equipment;

  // Field penting
  final int duration;
  final List<String> instructions;
  final List<String> targetMuscles; // Ini untuk Focus Area

  Workout({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.bodyParts,
    required this.equipment,
    this.duration = 30, // Request: Default 30 (Hardcode)
    this.instructions = const [],
    this.targetMuscles = const [],
  });

  factory Workout.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Workout(
      id: doc.id,
      name: data['name'] ?? 'Unknown Workout',
      imageUrl: data['imageUrl'] ?? '',

      // 1. DURATION: Tetap 30 (Hardcode sesuai request)
      duration: 30,

      // 2. INSTRUCTIONS: Dari Firebase
      instructions: (data['instructions'] is List)
          ? List<String>.from(data['instructions'])
          : [],

      // 3. TARGET MUSCLES: Dari Firebase (Penting untuk UI Focus Area)
      // Pastikan di Firebase nama fieldnya 'targetMuscles' (array string)
      targetMuscles: (data['targetMuscles'] is List)
          ? List<String>.from(data['targetMuscles'])
          : (data['bodyParts'] is List ? List<String>.from(data['bodyParts']) : []),
      // Fallback ke bodyParts jika targetMuscles kosong

      bodyParts: List<String>.from(data['bodyParts'] ?? []),
      equipment: List<String>.from(data['equipments'] ?? []),
    );
  }
}