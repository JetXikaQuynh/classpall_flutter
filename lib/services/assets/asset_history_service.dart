import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/assets_models/asset_history_model.dart';

class AssetHistoryService {
  final _db = FirebaseFirestore.instance;

  Stream<List<AssetHistory>> getHistory() {
    return _db
        .collection('asset_history')
        .orderBy('time', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
          .map((doc) => AssetHistory.fromFirestore(doc))
          .toList(),
    );
  }

  Future<void> addHistory({
    required String assetId,
    required String assetName,
    required String action,
    required String userName,
  }) async {
    await _db.collection('asset_history').add({
      'assetId': assetId,
      'assetName': assetName,
      'action': action,
      'userName': userName,
      'time': Timestamp.now(),
    });
  }
}
