import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/app_constants.dart';

class AdminAccessService {
  AdminAccessService(this._db);

  final FirebaseFirestore _db;

  Future<bool> isAdmin(String uid) async {
    // Admin allowlist skeleton:
    // Create a document at: admins/{uid}
    // and enforce access in Firestore rules (see firestore.rules skeleton).
    final doc = await _db.collection(AppConstants.colAdmins).doc(uid).get();
    return doc.exists;
  }
}
