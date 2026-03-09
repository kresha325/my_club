import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/announcement.dart';
import '../../utils/app_constants.dart';

class AnnouncementsRepository {
  AnnouncementsRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection(AppConstants.colAnnouncements);

  CollectionReference<Map<String, dynamic>> _responses(String announcementId) {
    return _col.doc(announcementId).collection('responses');
  }

  Stream<List<Announcement>> streamLatest({int limit = 100}) {
    return _col
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((d) => Announcement.fromFirestore(d.id, d.data()))
              .toList();
        });
  }

  Future<String> create(Announcement draft) async {
    final doc = _col.doc();
    final data = <String, dynamic>{
      ...draft.copyWith(id: doc.id).toFirestore(),
      'createdAt': FieldValue.serverTimestamp(),
    };
    await doc.set(data);
    return doc.id;
  }

  Future<void> update(Announcement item) {
    return _col.doc(item.id).set(item.toFirestore(), SetOptions(merge: true));
  }

  Future<void> delete(String id) => _col.doc(id).delete();

  Stream<AnnouncementResponse?> streamUserResponse({
    required String announcementId,
    required String uid,
  }) {
    return _responses(announcementId).doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      return AnnouncementResponse.fromFirestore(uid, snapshot.data()!);
    });
  }

  Stream<List<AnnouncementResponse>> streamResponses(String announcementId) {
    return _responses(
      announcementId,
    ).orderBy('respondedAt', descending: true).snapshots().map((snapshot) {
      return snapshot.docs
          .map((d) => AnnouncementResponse.fromFirestore(d.id, d.data()))
          .toList();
    });
  }

  Future<void> setResponse({
    required String announcementId,
    required AnnouncementResponse response,
  }) {
    final payload = <String, dynamic>{
      ...response.toFirestore(),
      'respondedAt': FieldValue.serverTimestamp(),
    };

    return _responses(
      announcementId,
    ).doc(response.uid).set(payload, SetOptions(merge: true));
  }
}
