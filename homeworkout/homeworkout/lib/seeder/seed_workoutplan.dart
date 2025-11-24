import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> seedWorkoutPlans() async {
  final firestore = FirebaseFirestore.instance;

  final plans = {
    "shoulder": {
      "name": "Shoulder Workout",
      "bodyPart": "Shoulder",
      "level": "Beginner",
      "duration": 10,
      "exercises": [
        {
          "exerciseId": "exr_41n2hbdZww1thMKz",
          "name": "Jump Squat",
          "sets": 3,
          "reps": "12"
        }
      ],
      "createdAt": FieldValue.serverTimestamp(),
    },
    "chest": {
      "name": "Chest Workout",
      "bodyPart": "Chest",
      "level": "Beginner",
      "duration": 12,
      "exercises": [
        {
          "exerciseId": "exr_41n2hadQgEEX8wDN",
          "name": "Triceps Dip",
          "sets": 3,
          "reps": "10–12"
        },
        {
          "exerciseId": "exr_41n2hdHtZrMPkcqY",
          "name": "Dumbbell Lying Floor Skull Crusher",
          "sets": 3,
          "reps": "10–12"
        }
      ],
      "createdAt": FieldValue.serverTimestamp(),
    },
    "arms": {
      "name": "Arm Workout",
      "bodyPart": "Arm",
      "level": "Beginner",
      "duration": 10,
      "exercises": [
        {
          "exerciseId": "exr_41n2hc2VrB8ofxrW",
          "name": "Lying Double Legs Biceps Curl with Towel",
          "sets": 3,
          "reps": "12"
        },
        {
          "exerciseId": "exr_41n2hadQgEEX8wDN",
          "name": "Triceps Dip",
          "sets": 3,
          "reps": "12"
        }
      ],
      "createdAt": FieldValue.serverTimestamp(),
    },
    "back": {
      "name": "Back Workout",
      "bodyPart": "Back",
      "level": "Beginner",
      "duration": 12,
      "exercises": [
        {
          "exerciseId": "exr_41n2hcdNGSAbNEZ3",
          "name": "Standing Elbow - Head Flexion",
          "sets": 3,
          "reps": "12"
        },
        {
          "exerciseId": "exr_41n2hd6SThQhAdnZ",
          "name": "Chin-ups",
          "sets": 3,
          "reps": "8–12"
        }
      ],
      "createdAt": FieldValue.serverTimestamp(),
    },
    "legs": {
      "name": "Leg & Glutes Workout",
      "bodyPart": "Legs",
      "level": "Beginner",
      "duration": 15,
      "exercises": [
        {
          "exerciseId": "exr_41n2haAabPyN5t8y",
          "name": "Side Lunge",
          "sets": 3,
          "reps": "12 each side"
        },
        {
          "exerciseId": "exr_41n2hbLX4XH8xgN7",
          "name": "Dumbbell Single Leg Calf Raise",
          "sets": 3,
          "reps": "15"
        }
      ],
      "createdAt": FieldValue.serverTimestamp(),
    },
    "core": {
      "name": "Core Workout",
      "bodyPart": "Core",
      "level": "Beginner",
      "duration": 8,
      "exercises": [
        {
          "exerciseId": "exr_41n2ha5iPFpN3hEJ",
          "name": "Bridge - Mountain Climber",
          "sets": 3,
          "reps": "20"
        }
      ],
      "createdAt": FieldValue.serverTimestamp(),
    },
    "full_body": {
      "name": "Full Body Workout",
      "bodyPart": "Full Body",
      "level": "Beginner",
      "duration": 18,
      "exercises": [
        {
          "exerciseId": "exr_41n2hfa11fPnk8y9",
          "name": "Elliptical Machine Walk",
          "sets": 1,
          "reps": "5 minutes"
        },
        {
          "exerciseId": "exr_41n2hbdZww1thMKz",
          "name": "Jump Squat",
          "sets": 3,
          "reps": "12"
        },
        {
          "exerciseId": "exr_41n2hcFJpBvAkXCP",
          "name": "Seated Row with Towel",
          "sets": 3,
          "reps": "12–15"
        }
      ],
      "createdAt": FieldValue.serverTimestamp(),
    },
    "custom": {
      "name": "Custom Workout",
      "bodyPart": "Custom",
      "level": "Any",
      "duration": 0,
      "exercises": [],
      "createdAt": FieldValue.serverTimestamp(),
    }
  };

  for (final entry in plans.entries) {
    await firestore.collection("workout_plan").doc(entry.key).set(entry.value);
  }

  print("Workout plans seeded successfully!");
}
