import 'package:cloud_functions/cloud_functions.dart';

class AutopostService {
  AutopostService(this._functions);

  final FirebaseFunctions _functions;

  Future<void> autopostNow({
    required String platform,
    required String contentType,
    required String contentId,
  }) async {
    // Calls Firebase Functions `autopostNow` (placeholder implementation).
    final callable = _functions.httpsCallable('autopostNow');
    await callable.call(<String, Object?>{
      'platform': platform,
      'contentType': contentType,
      'contentId': contentId,
    });
  }
}
