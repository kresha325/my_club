import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/club_match.dart';
import '../../utils/app_constants.dart';

class MatchesRepository {
  MatchesRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection(AppConstants.colMatches);

  Stream<List<ClubMatch>> streamLatest({int limit = 50}) {
    return _col
        .orderBy('matchAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((d) => ClubMatch.fromFirestore(d.id, d.data()))
              .toList();
        });
  }

  Future<String> create(ClubMatch draft) async {
    final doc = _col.doc();
    final data = <String, dynamic>{
      ...draft.copyWith(id: doc.id).toFirestore(),
      'createdAt': FieldValue.serverTimestamp(),
    };
    await doc.set(data);
    return doc.id;
  }

  Future<void> update(ClubMatch match) {
    return _col.doc(match.id).set(match.toFirestore(), SetOptions(merge: true));
  }

  Future<void> delete(String id) => _col.doc(id).delete();
}
