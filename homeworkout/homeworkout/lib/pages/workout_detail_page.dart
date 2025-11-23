import 'package:flutter/material.dart';
import 'package:homeworkout/models/workout_model.dart';

class WorkoutDetailPage extends StatelessWidget {
  final Workout workout;

  const WorkoutDetailPage({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(workout.name),
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  workout.imageUrl,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[900],
                    height: 220,
                    child: const Center(
                      child: Icon(Icons.broken_image, color: Colors.white),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              if (workout.targetMuscles.isNotEmpty)
                _section("Target Muscles", workout.targetMuscles),

              if (workout.secondaryMuscles.isNotEmpty)
                _section("Secondary Muscles", workout.secondaryMuscles),

              if (workout.bodyParts.isNotEmpty)
                _section("Body Parts", workout.bodyParts),

              if (workout.equipment.isNotEmpty)
                _section("Equipment", workout.equipment),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: items
              .map(
                (item) => Chip(
                  label: Text(
                    item.replaceAll("_", " "),
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.blueGrey[800],
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
