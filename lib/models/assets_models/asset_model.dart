class Asset {
  final String id;
  final String name;
  final String status;
  final String? borrowedBy;

  Asset({
    required this.id,
    required this.name,
    required this.status,
    this.borrowedBy,
  });

  factory Asset.fromFirestore(String id, Map<String, dynamic> data) {
    return Asset(
      id: id,
      name: data['name'],
      status: data['status'],
      borrowedBy: data['borrowedBy'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'status': status,
      'borrowedBy': borrowedBy,
      'createdAt': DateTime.now(),
    };
  }
}
