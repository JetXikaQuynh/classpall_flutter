import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/assets_models/asset_history_model.dart';

class AssetHistoryService {
  final _db = FirebaseFirestore.instance;

  // ================== GET ALL HISTORY ==================

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

  // ================== GET HISTORY BY USER ==================

  Stream<List<AssetHistory>> getHistoryByUser(String userId) {
    return _db
        .collection('asset_history')
        .where('userId', isEqualTo: userId)
        .orderBy('time', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
          .map((doc) => AssetHistory.fromFirestore(doc))
          .toList(),
    );
  }
}
