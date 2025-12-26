import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:classpall_flutter/models/event_models/event_model.dart';

class EventService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<EventModel>> getEvents() {
    return _db
        .collection('events')
        .orderBy('event_date', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => EventModel.fromFirestore(d)).toList());
  }

  Future<EventModel> getEventById(String eventId) async {
    final doc = await _db.collection('events').doc(eventId).get();
    return EventModel.fromFirestore(doc);
  }

  Future<void> createEvent(EventModel event) async {
    await _db.collection('events').add(event.toMap());
  }

  Future<void> updateRegisteredCount(String eventId, int value) async {
    await _db.collection('events').doc(eventId).update({
      'total_registered': value,
      'updated_at': Timestamp.now(),
    });
  }
}
