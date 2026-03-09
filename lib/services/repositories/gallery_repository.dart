import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/gallery_item.dart';
import '../../utils/app_constants.dart';

class GalleryRepository {
  GalleryRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection(AppConstants.colGallery);

  Stream<List<GalleryItem>> streamLatest({int limit = 50}) {
    return _col
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((d) => GalleryItem.fromFirestore(d.id, d.data()))
              .toList();
        });
  }

  Future<String> create(GalleryItem draft) async {
    final doc = _col.doc();
    final data = <String, dynamic>{
      ...draft.copyWith(id: doc.id).toFirestore(),
      'createdAt': FieldValue.serverTimestamp(),
    };
    await doc.set(data);
    return doc.id;
  }

  Future<void> update(GalleryItem item) {
    return _col.doc(item.id).set(item.toFirestore(), SetOptions(merge: true));
  }

  Future<void> delete(String id) => _col.doc(id).delete();
}
