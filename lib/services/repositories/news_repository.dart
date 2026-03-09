import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/news_item.dart';
import '../../utils/app_constants.dart';

class NewsRepository {
  NewsRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection(AppConstants.colNews);

  Stream<List<NewsItem>> streamLatest({int limit = 20}) {
    return _col
        .orderBy('publishedAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((d) => NewsItem.fromFirestore(d.id, d.data()))
              .toList();
        });
  }

  Future<String> create(NewsItem draft) async {
    final doc = _col.doc();
    final data = <String, dynamic>{
      ...draft.copyWith(id: doc.id).toFirestore(),
      'createdAt': FieldValue.serverTimestamp(),
    };
    await doc.set(data);
    return doc.id;
  }

  Future<void> update(NewsItem item) {
    return _col.doc(item.id).set(item.toFirestore(), SetOptions(merge: true));
  }

  Future<void> delete(String id) => _col.doc(id).delete();
}
