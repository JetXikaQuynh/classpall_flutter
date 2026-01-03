import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/fund_models/fund_expense_model.dart';

class FundExpenseService {
  final _ref = FirebaseFirestore.instance.collection('fund_expenses');

  /// ➕ Thêm khoản chi
  Future<void> addExpense({
    required String title,
    required int amount,
    String note = '',
    required String createdBy,
  }) async {
    await _ref.add({
      'title': title,
      'amount': amount,
      'note': note,
      'createdBy': createdBy,
      'createdAt': Timestamp.now(),
    });
  }

  /// 📥 Lấy danh sách khoản chi (realtime)
  Stream<List<FundExpense>> getExpenses() {
    return _ref
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) =>
          snap.docs.map((d) => FundExpense.fromFirestore(d)).toList(),
    );
  }

  /// ➗ Tính tổng chi (realtime)
  Stream<int> getTotalExpense() {
    return getExpenses().map(
          (expenses) =>
          expenses.fold(0, (sum, e) => sum + e.amount),
    );
  }
}
