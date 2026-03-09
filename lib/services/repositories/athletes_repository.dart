import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/athlete.dart';
import '../../utils/app_constants.dart';

class AthletesRepository {
  AthletesRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection(AppConstants.colAthletes);

  Stream<List<Athlete>> streamAll() {
    return _col.orderBy('createdAt', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs
          .map((d) => Athlete.fromFirestore(d.id, d.data()))
          .toList();
    });
  }

  Future<String> create(Athlete draft) async {
    final doc = _col.doc();
    final data = <String, dynamic>{
      ...draft.copyWith(id: doc.id).toFirestore(),
      'createdAt': FieldValue.serverTimestamp(),
    };
    await doc.set(data);
    return doc.id;
  }

  Future<void> update(Athlete athlete) {
    return _col
        .doc(athlete.id)
        .set(athlete.toFirestore(), SetOptions(merge: true));
  }

  Future<void> delete(String id) => _col.doc(id).delete();
}
