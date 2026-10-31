import 'dart:developer' as dev;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../services/analytics_service.dart';
import '../services/camp_config_service.dart';
import '../services/notification_service.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/auth_usecases.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

import '../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/profile_usecases.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';

import '../../features/programs/data/datasources/programs_remote_data_source.dart';
import '../../features/programs/data/repositories/programs_repository_impl.dart';
import '../../features/programs/domain/repositories/programs_repository.dart';
import '../../features/programs/domain/usecases/programs_usecases.dart';
import '../../features/programs/presentation/bloc/programs_bloc.dart';

import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';

import '../../features/announcements/data/datasources/announcements_remote_data_source.dart';
import '../../features/announcements/data/repositories/announcements_repository_impl.dart';
import '../../features/announcements/domain/repositories/announcements_repository.dart';
import '../../features/announcements/domain/usecases/announcements_usecases.dart';
import '../../features/announcements/presentation/bloc/announcements_bloc.dart';

import '../../features/podium/data/datasources/podium_remote_data_source.dart';
import '../../features/podium/data/repositories/podium_repository_impl.dart';
import '../../features/podium/domain/repositories/podium_repository.dart';
import '../../features/podium/domain/usecases/podium_usecases.dart';
import '../../features/podium/presentation/bloc/podium_bloc.dart';

import '../../features/tests/data/services/test_firestore_service.dart';
import '../../features/tests/presentation/bloc/test_bloc.dart';

final sl = GetIt.instance;

Future<void> initInjector() async {
  dev.log('Initializing Dependency Injection Container...', name: 'DI_CONTAINER');

  // External & Cache Configuration
  sl.registerLazySingleton<FirebaseAnalytics>(() => FirebaseAnalytics.instance);
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn.instance);
  sl.registerLazySingleton<FirebaseMessaging>(() => FirebaseMessaging.instance);
  sl.registerLazySingleton<FlutterLocalNotificationsPlugin>(() => FlutterLocalNotificationsPlugin());
  
  final firestore = FirebaseFirestore.instance;
  firestore.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  sl.registerLazySingleton<FirebaseFirestore>(() => firestore);

  // Core Services
  sl.registerLazySingleton<AnalyticsService>(
    () => AnalyticsService(analytics: sl()),
  );
  sl.registerLazySingleton<NotificationService>(
    () => NotificationService(
      fcm: sl(),
      localNotifications: sl(),
      firestore: sl(),
    ),
  );
  sl.registerLazySingleton<CampConfigService>(
    () => CampConfigService(firestore: sl()),
  );

  // Data Sources & Services
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      googleSignIn: sl(),
      firestore: sl(),
    ),
  );
  sl.registerLazySingleton<ProgramsRemoteDataSource>(
    () => ProgramsRemoteDataSourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<AnnouncementsRemoteDataSource>(
    () => AnnouncementsRemoteDataSourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<PodiumRemoteDataSource>(
    () => PodiumRemoteDataSourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<TestFirestoreService>(
    () => TestFirestoreService(firestore: sl()),
  );
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(
      firestore: sl(),
      testFirestoreService: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ProgramsRepository>(
    () => ProgramsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<AnnouncementsRepository>(
    () => AnnouncementsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<PodiumRepository>(
    () => PodiumRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => SignInWithGoogleUseCase(sl()));
  sl.registerLazySingleton(() => CompleteProfileUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));

  sl.registerLazySingleton(() => GetUpcomingProgramsUseCase(sl()));
  sl.registerLazySingleton(() => GetTodayOrNextProgramUseCase(sl()));

  sl.registerLazySingleton(() => GetAnnouncementsUseCase(sl()));

  sl.registerLazySingleton(() => GetLeaderboardUseCase(sl()));

  sl.registerLazySingleton(() => StreamProfileTestHistoryUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerLazySingleton(() => GetTestCorrectionDetailsUseCase(sl()));

  // BLoCs
  sl.registerFactory(
    () => AuthBloc(
      getCurrentUserUseCase: sl(),
      signInWithGoogleUseCase: sl(),
      completeProfileUseCase: sl(),
      signOutUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => ProfileBloc(
      streamProfileTestHistoryUseCase: sl(),
      updateProfileUseCase: sl(),
      getTestCorrectionDetailsUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => ProgramsBloc(getUpcomingProgramsUseCase: sl()),
  );
  sl.registerFactory(
    () => DashboardBloc(getTodayOrNextProgramUseCase: sl()),
  );
  sl.registerFactory(
    () => AnnouncementsBloc(getAnnouncementsUseCase: sl()),
  );
  sl.registerFactory(
    () => PodiumBloc(getLeaderboardUseCase: sl()),
  );
  sl.registerFactory(
    () => TestBloc(firestoreService: sl()),
  );

  dev.log('Dependency Injection Container initialized successfully', name: 'DI_CONTAINER');
}
