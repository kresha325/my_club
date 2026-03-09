import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/autopost_job.dart';
import '../../utils/app_constants.dart';

class AutopostJobsRepository {
  AutopostJobsRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection(AppConstants.colAutopostJobs);

  Stream<List<AutopostJob>> streamRecent({int limit = 50}) {
    return _col
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((d) => AutopostJob.fromFirestore(d.id, d.data()))
              .toList();
        });
  }

  Future<String> create(AutopostJob draft) async {
    final doc = _col.doc();
    final data = <String, dynamic>{
      ...draft.copyWith(id: doc.id).toFirestore(),
      'createdAt': FieldValue.serverTimestamp(),
      'status': draft.status.isEmpty ? 'queued' : draft.status,
    };
    await doc.set(data);
    return doc.id;
  }

  Future<void> update(AutopostJob job) {
    return _col.doc(job.id).set(job.toFirestore(), SetOptions(merge: true));
  }

  Future<void> delete(String id) => _col.doc(id).delete();
}
