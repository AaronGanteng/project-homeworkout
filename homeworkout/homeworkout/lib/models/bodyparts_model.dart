class BodyPart {
  final String id;
  final String name;
  final String imageUrl;

  BodyPart({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory BodyPart.fromMap(String id, Map<String, dynamic> data) {
    return BodyPart(
      id: id,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "imageUrl": imageUrl,
    };
  }
}
