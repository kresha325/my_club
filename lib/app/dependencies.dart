import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../services/autopost/autopost_service.dart';
import '../services/firebase/admin_access_service.dart';
import '../services/firebase/auth_service.dart';
import '../services/firebase/media_storage_service.dart';
import '../services/repositories/ads_repository.dart';
import '../services/repositories/athletes_repository.dart';
import '../services/repositories/autopost_jobs_repository.dart';
import '../services/repositories/events_repository.dart';
import '../services/repositories/gallery_repository.dart';
import '../services/repositories/matches_repository.dart';
import '../services/repositories/news_repository.dart';
import '../services/repositories/sponsors_repository.dart';
import '../services/repositories/training_sessions_repository.dart';
import '../services/repositories/announcements_repository.dart';
import '../services/repositories/member_profiles_repository.dart';
import '../services/repositories/staff_repository.dart';

class AppDependencies {
  AppDependencies._({
    required this.auth,
    required this.firestore,
    required this.storage,
    required this.functions,
  });

  factory AppDependencies.create() {
    return AppDependencies._(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
      storage: FirebaseStorage.instance,
      functions: FirebaseFunctions.instance,
    );
  }

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;
  final FirebaseFunctions functions;

  late final AuthService authService = AuthService(auth);
  late final AdminAccessService adminAccessService = AdminAccessService(
    firestore,
  );
  late final MediaStorageService mediaStorageService = MediaStorageService(
    storage,
  );
  late final AutopostService autopostService = AutopostService(functions);

  late final AthletesRepository athletesRepository = AthletesRepository(
    firestore,
  );
  late final NewsRepository newsRepository = NewsRepository(firestore);
  late final EventsRepository eventsRepository = EventsRepository(firestore);
  late final MatchesRepository matchesRepository = MatchesRepository(firestore);
  late final GalleryRepository galleryRepository = GalleryRepository(firestore);
  late final SponsorsRepository sponsorsRepository = SponsorsRepository(
    firestore,
  );
  late final AdsRepository adsRepository = AdsRepository(firestore);
  late final AutopostJobsRepository autopostJobsRepository =
      AutopostJobsRepository(firestore);
  late final TrainingSessionsRepository trainingSessionsRepository =
      TrainingSessionsRepository(firestore);
  late final AnnouncementsRepository announcementsRepository =
      AnnouncementsRepository(firestore);
  late final MemberProfilesRepository memberProfilesRepository =
      MemberProfilesRepository(firestore);
  late final StaffRepository staffRepository = StaffRepository(firestore);
}

class DependenciesScope extends InheritedWidget {
  const DependenciesScope({
    required this.deps,
    required super.child,
    super.key,
  });

  final AppDependencies deps;

  static AppDependencies of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<DependenciesScope>();
    assert(scope != null, 'DependenciesScope not found in widget tree.');
    return scope!.deps;
  }

  @override
  bool updateShouldNotify(DependenciesScope oldWidget) => false;
}
