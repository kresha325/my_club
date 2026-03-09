import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/ad.dart';
import '../../utils/app_constants.dart';

class AdsRepository {
  AdsRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection(AppConstants.colAds);

  Stream<List<Ad>> streamAll({int limit = 50}) {
    return _col
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((d) => Ad.fromFirestore(d.id, d.data()))
              .toList();
        });
  }

  Future<String> create(Ad draft) async {
    final doc = _col.doc();
    final data = <String, dynamic>{
      ...draft.copyWith(id: doc.id).toFirestore(),
      'createdAt': FieldValue.serverTimestamp(),
    };
    await doc.set(data);
    return doc.id;
  }

  Future<void> update(Ad ad) {
    return _col.doc(ad.id).set(ad.toFirestore(), SetOptions(merge: true));
  }

  Future<void> delete(String id) => _col.doc(id).delete();
}
