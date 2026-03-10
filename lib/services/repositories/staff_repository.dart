import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/staff_member.dart';
import '../../utils/app_constants.dart';

class StaffRepository {
  StaffRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection(AppConstants.colStaff);

  Stream<List<StaffMember>> streamAll() {
    return _col.orderBy('createdAt', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs
          .map((d) => StaffMember.fromFirestore(d.id, d.data()))
          .toList();
    });
  }

  Future<String> create(StaffMember draft) async {
    final doc = _col.doc();
    final data = <String, dynamic>{
      ...draft.copyWith(id: doc.id).toFirestore(),
      'createdAt': FieldValue.serverTimestamp(),
    };
    await doc.set(data);
    return doc.id;
  }

  Future<void> update(StaffMember staff) {
    return _col.doc(staff.id).set(staff.toFirestore(), SetOptions(merge: true));
  }

  Future<void> delete(String id) => _col.doc(id).delete();
}
