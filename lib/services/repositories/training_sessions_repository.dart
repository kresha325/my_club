import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/training_session.dart';
import '../../utils/app_constants.dart';

class TrainingSessionsRepository {
  TrainingSessionsRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection(AppConstants.colTrainingSessions);

  Stream<List<TrainingSession>> streamUpcoming({int limit = 100}) {
    return _col
        .orderBy('startAt', descending: false)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((d) => TrainingSession.fromFirestore(d.id, d.data()))
              .toList();
        });
  }

  Future<String> create(TrainingSession draft) async {
    final doc = _col.doc();
    final data = <String, dynamic>{
      ...draft.copyWith(id: doc.id).toFirestore(),
      'createdAt': FieldValue.serverTimestamp(),
    };
    await doc.set(data);
    return doc.id;
  }

  Future<void> update(TrainingSession session) {
    return _col
        .doc(session.id)
        .set(session.toFirestore(), SetOptions(merge: true));
  }

  Future<void> delete(String id) => _col.doc(id).delete();
}
