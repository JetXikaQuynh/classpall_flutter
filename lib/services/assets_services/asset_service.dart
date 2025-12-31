import 'package:classpall_flutter/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/models/assets_models/asset_model.dart';

class AssetService {
  final _assetRef =
  FirebaseFirestore.instance.collection('assets');
  final _historyRef =
  FirebaseFirestore.instance.collection('asset_history');
  final UserService _userService = UserService();

  // ================== GET ==================

  // Lấy danh sách tài sản realtime
  Stream<List<Asset>> getAssets() {
    return _assetRef.snapshots().map(
          (snapshot) => snapshot.docs
          .map((doc) =>
          Asset.fromFirestore(doc.id, doc.data()))
          .toList(),
    );
  }

  // ================== ADD ==================

  // Thêm tài sản
  Future<void> addAsset(String name) async {
    await _assetRef.add({
      'name': name,
      'status': 'available',
      'borrowedById': null,
      'borrowedByName': null,
      'borrowedAt': null,
      'createdAt': Timestamp.now(),
    });
  }

  // ================== BORROW ==================

  // Mượn tài sản (lấy user từ FirebaseAuth)
  Future<void> borrowAsset({
    required String assetId,
    required String assetName,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final user = await _userService.getUserById(uid);
    final userName = user?.fullName ?? 'Không rõ';

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

  // ================== RETURN ==================

  // Trả tài sản (chỉ user đang mượn mới được trả)
  Future<void> returnAsset({
    required String assetId,
    required String assetName,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final user = await _userService.getUserById(uid);
    final userName = user?.fullName ?? 'Không rõ';

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

  // ================== DELETE ==================

  // Xóa tài sản
  Future<void> deleteAsset(String assetId) async {
    await _assetRef.doc(assetId).delete();
  }
}
