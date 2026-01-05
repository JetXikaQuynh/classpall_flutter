import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/fund_models/fund_collection_model.dart';

class FundCollectionService {
  final _collectionRef =
  FirebaseFirestore.instance.collection('fund_collections');

  /// Lấy danh sách khoản thu (realtime)
  Stream<List<FundCollection>> getCollections() {
    return _collectionRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
          .map((d) => FundCollection.fromFirestore(d))
          .toList(),
    );
  }

  /// Tạo khoản thu mới
  Future<String> createCollection({
    required String title,
    required int amountPerUser,
    required String teamId,
    required String createdBy,
  }) async {
    final doc = await _collectionRef.add({
      'title': title,
      'amountPerUser': amountPerUser,
      'teamId': teamId,
      'createdBy': createdBy,
      'active': true,
      'createdAt': Timestamp.now(),
    });

    return doc.id;
  }
}
