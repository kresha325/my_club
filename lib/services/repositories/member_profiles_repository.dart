import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/app_constants.dart';

class MemberProfilesRepository {
  MemberProfilesRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection(AppConstants.colMemberProfiles);

  Future<String?> getFullName(String uid) async {
    final snapshot = await _col.doc(uid).get();
    final data = snapshot.data();
    final value = data?['fullName'] as String?;
    if (value == null) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  Future<void> saveFullName({required String uid, required String fullName}) {
    return _col.doc(uid).set({
      'uid': uid,
      'fullName': fullName.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
