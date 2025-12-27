import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_saver/file_saver.dart';

class EventExportService {
  static final _firestore = FirebaseFirestore.instance;

  /// Xuất danh sách sinh viên THAM GIA (joined)
  static Future<void> exportEventParticipants(String eventId) async {
    try {
      // 1. Lấy registrations joined
      final regSnap = await _firestore
          .collection('event_registrations')
          .where('event_id', isEqualTo: eventId)
          .where('status', isEqualTo: 'joined')
          .get();

      // 2. Header CSV
      final rows = <List<String>>[
        ['STT', 'Ho ten', 'Email', 'Lop'],
      ];

      int index = 1;

      for (final doc in regSnap.docs) {
        final userId = doc['user_id'];

        final userDoc =
            await _firestore.collection('users').doc(userId).get();

        if (!userDoc.exists) continue;

        final user = userDoc.data()!;
        rows.add([
          index.toString(),
          user['fullname'] ?? '',
          user['email'] ?? '',
          user['classname'] ?? '',
        ]);
        index++;
      }

      // 3. Convert CSV
      final csv = const ListToCsvConverter().convert(rows);
      final bytes = Uint8List.fromList(utf8.encode(csv));

      // 4. SAVE (WEB + MOBILE)
      await FileSaver.instance.saveFile(
        name: 'event_${eventId}_participants',
        bytes: bytes,
        ext: 'csv',
        mimeType: MimeType.csv,
      );
    } catch (e) {
      throw Exception('Xuất file thất bại: $e');
    }
  }
}
