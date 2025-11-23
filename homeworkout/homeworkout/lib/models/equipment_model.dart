class Equipment {
  final String id;
  final String name;
  final String imageUrl;

  Equipment({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory Equipment.fromMap(String id, Map<String, dynamic> data) {
    return Equipment(
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
