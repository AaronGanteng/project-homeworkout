import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homeworkout/models/equipment_model.dart';

class EquipmentService {
  final _db = FirebaseFirestore.instance;

  Stream<List<Equipment>> getEquipments() {
    return _db.collection("equipments").snapshots().map(
          (snapshot) => snapshot.docs
          .map((doc) => Equipment.fromMap(doc.id, doc.data()))
          .toList(),
    );
  }
}
