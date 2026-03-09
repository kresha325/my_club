import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/club_event.dart';
import '../../utils/app_constants.dart';

class EventsRepository {
  EventsRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection(AppConstants.colEvents);

  Stream<List<ClubEvent>> streamUpcoming({int limit = 50}) {
    return _col
        .orderBy('startAt', descending: false)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((d) => ClubEvent.fromFirestore(d.id, d.data()))
              .toList();
        });
  }

  Future<String> create(ClubEvent draft) async {
    final doc = _col.doc();
    final data = <String, dynamic>{
      ...draft.copyWith(id: doc.id).toFirestore(),
      'createdAt': FieldValue.serverTimestamp(),
    };
    await doc.set(data);
    return doc.id;
  }

  Future<void> update(ClubEvent event) {
    return _col.doc(event.id).set(event.toFirestore(), SetOptions(merge: true));
  }

  Future<void> delete(String id) => _col.doc(id).delete();
}
