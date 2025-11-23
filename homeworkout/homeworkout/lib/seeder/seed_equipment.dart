import 'package:cloud_firestore/cloud_firestore.dart';

class EquipmentSeeder {
  static Future<void> uploadEquipments() async {
    final db = FirebaseFirestore.instance;

    final equipments = {
      "assisted": {
        "name": "ASSISTED",
        "imageUrl": "https://cdn.exercisedb.dev/equipments/equipment-assisted.webp"
      },
      "band": {
        "name": "BAND",
        "imageUrl": "https://cdn.exercisedb.dev/equipments/equipment-band.webp"
      },
      "barbell": {
        "name": "BARBELL",
        "imageUrl": "https://cdn.exercisedb.dev/equipments/equipment-barbell.webp"
      },
      "battling_rope": {
        "name": "BATTLING ROPE",
        "imageUrl": "https://cdn.exercisedb.dev/equipments/equipment-Battling-Rope.webp"
      },
      "body_weight": {
        "name": "BODY WEIGHT",
        "imageUrl": "https://cdn.exercisedb.dev/equipments/equipment-Body-weight.webp"
      },
      "bosu_ball": {
        "name": "BOSU BALL",
        "imageUrl": "https://cdn.exercisedb.dev/equipments/equipment-Bosu-ball.webp"
      },
      "cable": {
        "name": "CABLE",
        "imageUrl": "https://cdn.exercisedb.dev/equipments/equipment-Cable-1.webp"
      },
      "dumbbell": {
        "name": "DUMBBELL",
        "imageUrl": "https://cdn.exercisedb.dev/equipments/equipment-Dumbbell.webp"
      },
      "ez_barbell": {
        "name": "EZ BARBELL",
        "imageUrl": "https://cdn.exercisedb.dev/equipments/equipment-EZ-Barbell.webp"
      },
      "hammer": {
        "name": "HAMMER",
        "imageUrl": "https://cdn.exercisedb.dev/equipments/equipment-hammer.webp"
      },
      "kettlebell": {
        "name": "KETTLEBELL",
        "imageUrl": "https://cdn.exercisedb.dev/equipments/equipment-Kettlebell.webp"
      },
      "leverage_machine": {
        "name": "LEVERAGE MACHINE",
        "imageUrl": "https://cdn.exercisedb.dev/equipments/equipment-Leverage-machine.webp"
      },
      "medicine_ball": {
        "name": "MEDICINE BALL",
        "imageUrl": "https://cdn.exercisedb.dev/equipments/equipment-Medicine-Ball.webp"
      },
      "olympic_barbell": {
        "name": "OLYMPIC BARBELL",
        "imageUrl": "https://cdn.exercisedb.dev/equipments/equipment-Olympic-barbell.webp"
      },
      "power_sled": {
        "name": "POWER SLED",
        "imageUrl": "https://cdn.exercisedb.dev/equipments/equipment-Power-Sled.webp"
      },
      "resistance_band": {
        "name": "RESISTANCE BAND",
        "imageUrl": "https://cdn.exercisedb.dev/equipments/equipment-Resistance-Band.webp"
      },
      "roll": {
        "name": "ROLL",
        "imageUrl": "https://cdn.exercisedb.dev/equipments/equipment-Massage-Roller.webp"
      },
      "rollball": {
        "name": "ROLLBALL",
        "imageUrl": "https://cdn.exercisedb.dev/equipments/equipment-Roll-Ball.webp"
      },
      "rope": {
        "name": "ROPE",
        "imageUrl": "https://cdn.exercisedb.dev/equipments/equipment-Jump-Rope.webp"
      },
      "sled_machine": {
        "name": "SLED MACHINE",
        "imageUrl": "https://cdn.exercisedb.dev/equipments/equipment-Sled-machine.webp"
      },
      "smith_machine": {
        "name": "SMITH MACHINE",
        "imageUrl": "https://cdn.exercisedb.dev/equipments/equipment-Smith-machine.webp"
      },
      "stability_ball": {
        "name": "STABILITY BALL",
        "imageUrl": "https://cdn.exercisedb.dev/equipments/equipment-Stability-ball.webp"
      },
      "stick": {
        "name": "STICK",
        "imageUrl": "https://cdn.exercisedb.dev/equipments/equipment-Stick.webp"
      },
      "suspension": {
        "name": "SUSPENSION",
        "imageUrl": "https://cdn.exercisedb.dev/equipments/equipment-Suspension.webp"
      },
      "trap_bar": {
        "name": "TRAP BAR",
        "imageUrl": "https://cdn.exercisedb.dev/equipments/equipment-Trap-bar.webp"
      },
      "vibrate_plate": {
        "name": "VIBRATE PLATE",
        "imageUrl": "https://cdn.exercisedb.dev/equipments/equipment-Vibrate-Plate.webp"
      },
      "weighted": {
        "name": "WEIGHTED",
        "imageUrl": "https://cdn.exercisedb.dev/equipments/equipment-Weighted.webp"
      },
    };

    for (final entry in equipments.entries) {
      await db.collection("equipments").doc(entry.key).set(entry.value);
    }

    print("Workout berhasil di-upload ke Firestore!");
  }
}
