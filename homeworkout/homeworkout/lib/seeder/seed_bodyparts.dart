import 'package:cloud_firestore/cloud_firestore.dart';

class BodyPartsSeeder {
  static Future<void> uploadBodyParts() async {
    final db = FirebaseFirestore.instance;

    final bodyParts = {
      "back": {
        "name": "BACK",
        "imageUrl": "https://cdn.exercisedb.dev/bodyparts/back.webp"
      },
      "calves": {
        "name": "CALVES",
        "imageUrl": "https://cdn.exercisedb.dev/bodyparts/calves.webp"
      },
      "chest": {
        "name": "CHEST",
        "imageUrl": "https://cdn.exercisedb.dev/bodyparts/chest.webp"
      },
      "forearms": {
        "name": "FOREARMS",
        "imageUrl": "https://cdn.exercisedb.dev/bodyparts/forearms.webp"
      },
      "hips": {
        "name": "HIPS",
        "imageUrl": "https://cdn.exercisedb.dev/bodyparts/hips.webp"
      },
      "neck": {
        "name": "NECK",
        "imageUrl": "https://cdn.exercisedb.dev/bodyparts/neck.webp"
      },
      "shoulders": {
        "name": "SHOULDERS",
        "imageUrl": "https://cdn.exercisedb.dev/bodyparts/shoulders.webp"
      },
      "thighs": {
        "name": "THIGHS",
        "imageUrl": "https://cdn.exercisedb.dev/bodyparts/thighs.webp"
      },
      "waist": {
        "name": "WAIST",
        "imageUrl": "https://cdn.exercisedb.dev/bodyparts/waist.webp"
      },
      "hands": {
        "name": "HANDS",
        "imageUrl": "https://cdn.exercisedb.dev/bodyparts/hands.webp"
      },
      "feet": {
        "name": "FEET",
        "imageUrl": "https://cdn.exercisedb.dev/bodyparts/feet.webp"
      },
      "face": {
        "name": "FACE",
        "imageUrl": "https://cdn.exercisedb.dev/bodyparts/face.webp"
      },
      "full_body": {
        "name": "FULL BODY",
        "imageUrl": "https://cdn.exercisedb.dev/bodyparts/fullbody.webp"
      },
      "biceps": {
        "name": "BICEPS",
        "imageUrl": "https://cdn.exercisedb.dev/bodyparts/biceps.webp"
      },
      "upper_arms": {
        "name": "UPPER ARMS",
        "imageUrl": "https://cdn.exercisedb.dev/bodyparts/biceps.webp"
      },
      "triceps": {
        "name": "TRICEPS",
        "imageUrl": "https://cdn.exercisedb.dev/bodyparts/triceps.webp"
      },
      "hamstrings": {
        "name": "HAMSTRINGS",
        "imageUrl": "https://cdn.exercisedb.dev/bodyparts/hamstrings.webp"
      },
    };

    for (final entry in bodyParts.entries) {
      await db.collection("body_parts").doc(entry.key).set(entry.value);
    }

    print("Workout berhasil di-upload ke Firestore!");
  }
}
