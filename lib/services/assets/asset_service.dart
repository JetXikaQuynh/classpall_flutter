import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/assets_models/asset_model.dart';

class AssetService {
  final _assetRef =
  FirebaseFirestore.instance.collection('assets');
  final _historyRef =
  FirebaseFirestore.instance.collection('asset_history');

  // Lấy danh sách tài sản realtime
  Stream<List<Asset>> getAssets() {
    return _assetRef.snapshots().map(
          (snapshot) => snapshot.docs
          .map((doc) =>
          Asset.fromFirestore(doc.id, doc.data()))
          .toList(),
    );
  }

  // Thêm tài sản
  Future<void> addAsset(String name) async {
    await _assetRef.add({
      'name': name,
      'status': 'available',
      'borrowedBy': null,
      'createdAt': Timestamp.now(),
    });
  }

  // Mượn tài sản
  Future<void> borrowAsset({
    required String assetId,
    required String assetName,
    required String userName,
  }) async {
    await _assetRef.doc(assetId).update({
      'status': 'borrowed',
      'borrowedBy': userName,
    });

    await _historyRef.add({
      'assetId': assetId,
      'assetName': assetName,
      'action': 'borrowed',
      'userName': userName,
      'time': Timestamp.now(),
    });
  }

  // Trả tài sản
  Future<void> returnAsset({
    required String assetId,
    required String assetName,
    required String userName,
  }) async {
    await _assetRef.doc(assetId).update({
      'status': 'available',
      'borrowedBy': null,
    });

    await _historyRef.add({
      'assetId': assetId,
      'assetName': assetName,
      'action': 'returned',
      'userName': userName,
      'time': Timestamp.now(),
    });
  }

  // Xóa tài sản
  Future<void> deleteAsset(String assetId) async {
    await _assetRef.doc(assetId).delete();
  }
}
