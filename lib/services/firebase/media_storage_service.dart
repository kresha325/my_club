import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class MediaStorageService {
  MediaStorageService(this._storage);

  final FirebaseStorage _storage;

  Future<String> uploadBytes({
    required String path,
    required Uint8List bytes,
    String? contentType,
  }) async {
    final ref = _storage.ref().child(path);
    final metadata = SettableMetadata(contentType: contentType);
    await ref.putData(bytes, metadata);
    return ref.getDownloadURL();
  }
}
