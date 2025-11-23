import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homeworkout/models/bodyparts_model.dart';

class BodyPartService {
  final _db = FirebaseFirestore.instance;

  Stream<List<BodyPart>> getBodyParts() {
    return _db.collection("body_parts").snapshots().map(
          (snapshot) => snapshot.docs
          .map((doc) => BodyPart.fromMap(doc.id, doc.data()))
          .toList(),
    );
  }

}
