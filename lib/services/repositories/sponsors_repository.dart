import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/sponsor.dart';
import '../../utils/app_constants.dart';

class SponsorsRepository {
  SponsorsRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection(AppConstants.colSponsors);

  Stream<List<Sponsor>> streamAll() {
    return _col.orderBy('tier').snapshots().map((snapshot) {
      return snapshot.docs
          .map((d) => Sponsor.fromFirestore(d.id, d.data()))
          .toList();
    });
  }

  Future<String> create(Sponsor draft) async {
    final doc = _col.doc();
    final data = <String, dynamic>{
      ...draft.copyWith(id: doc.id).toFirestore(),
      'createdAt': FieldValue.serverTimestamp(),
    };
    await doc.set(data);
    return doc.id;
  }

  Future<void> update(Sponsor sponsor) {
    return _col
        .doc(sponsor.id)
        .set(sponsor.toFirestore(), SetOptions(merge: true));
  }

  Future<void> delete(String id) => _col.doc(id).delete();
}
