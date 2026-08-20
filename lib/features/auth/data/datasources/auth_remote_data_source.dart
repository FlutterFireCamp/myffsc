import 'dart:developer' as dev;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/core.dart';
import '../models/user_model.dart';

class UserCanceledException implements Exception {
  final String message;
  const UserCanceledException([this.message = "Connexion Google annulée par l'utilisateur."]);

  @override
  String toString() => message;
}

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithGoogle();
  Future<UserModel?> getCurrentUser();
  Future<UserModel> completeProfile({
    required String userId,
    required Map<String, dynamic> data,
  });
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;
  final FirebaseFirestore firestore;
  final String? serverClientId;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.googleSignIn,
    required this.firestore,
    this.serverClientId,
  });

  @override
  Future<UserModel> completeProfile({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    try {
      dev.log('Completing profile for user $userId in Firestore...', name: 'AUTH_REMOTE_DS');
      final updatePayload = Map<String, dynamic>.from(data);
      updatePayload['updatedAt'] = FieldValue.serverTimestamp();

      final docRef = firestore.collection('users').doc(userId);
      await docRef.update(updatePayload);

      final updatedSnap = await docRef.get();
      if (!updatedSnap.exists || updatedSnap.data() == null) {
        throw Exception("Document utilisateur introuvable après mise à jour.");
      }

      return UserModel.fromMap(updatedSnap.data()!, updatedSnap.id);
    } catch (e, st) {
      dev.log('Error completing profile', name: 'AUTH_REMOTE_DS', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      dev.log('Initiating Google Sign-In flow...', name: 'AUTH_REMOTE_DS');

      const envServerClientId = String.fromEnvironment('WEB_CLIENT_ID');
      final clientIdToUse = (serverClientId != null && serverClientId!.isNotEmpty)
          ? serverClientId
          : (envServerClientId.isNotEmpty
              ? envServerClientId
              : '940039203312-dgmo6fr82npo9ts44c1vrr4f7rtild2b.apps.googleusercontent.com');

      dev.log('Initializing GoogleSignIn with serverClientId ($clientIdToUse)...', name: 'AUTH_REMOTE_DS');
      await googleSignIn.initialize(
        serverClientId: clientIdToUse,
      );

      GoogleSignInAccount? googleUser;
      try {
        googleUser = await googleSignIn.authenticate();
      } on GoogleSignInException catch (e) {
        if (e.code == GoogleSignInExceptionCode.canceled) {
          dev.log('Google Sign-In cancelled by user', name: 'AUTH_REMOTE_DS');
          throw const UserCanceledException();
        } else if (e.code == GoogleSignInExceptionCode.clientConfigurationError) {
          dev.log(
            'Google Sign-In client configuration error. serverClientId must be provided in Firebase Console / WEB_CLIENT_ID env variable.',
            name: 'AUTH_REMOTE_DS',
            error: e,
          );
          throw Exception(
            "Configuration Google Sign-In requise : veuillez vérifier le Web Client ID dans Firebase Console.",
          );
        }
        rethrow;
      }

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      String? accessToken;

      try {
        final authClient = googleUser.authorizationClient;
        final clientAuth = await authClient.authorizationForScopes(['email', 'profile']);
        accessToken = clientAuth?.accessToken;
      } catch (e) {
        dev.log('Could not retrieve accessToken for scopes: $e', name: 'AUTH_REMOTE_DS');
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await firebaseAuth.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        dev.log('Firebase User is null after credential sign-in', name: 'AUTH_REMOTE_DS');
        throw Exception("Échec de la récupération de l'utilisateur Firebase.");
      }

      final email = firebaseUser.email ?? googleUser.email;
      final photoUrl = firebaseUser.photoURL ?? googleUser.photoUrl;
      final displayName = firebaseUser.displayName ?? googleUser.displayName;

      return await _fetchAndSyncExistingUserDoc(
        firebaseUid: firebaseUser.uid,
        email: email,
        displayName: displayName,
        googlePhotoUrl: photoUrl,
      );
    } on UserCanceledException {
      rethrow;
    } catch (e, stackTrace) {
      dev.log('Error during signInWithGoogle', name: 'AUTH_REMOTE_DS', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final firebaseUser = firebaseAuth.currentUser;
      if (firebaseUser == null) {
        dev.log('No currentUser found in FirebaseAuth', name: 'AUTH_REMOTE_DS');
        return null;
      }

      return await _fetchAndSyncExistingUserDoc(
        firebaseUid: firebaseUser.uid,
        email: firebaseUser.email,
        displayName: firebaseUser.displayName,
        googlePhotoUrl: firebaseUser.photoURL,
      );
    } catch (e, stackTrace) {
      dev.log('Error fetching getCurrentUser', name: 'AUTH_REMOTE_DS', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Vérifie si l'adresse e-mail figure dans le document config/participants-emails (champ emails).
  Future<bool> _isEmailInParticipantsList(String email) async {
    if (email.trim().isEmpty) return false;
    final normalizedEmail = email.trim().toLowerCase();

    try {
      dev.log('Vérification de $normalizedEmail dans config/participants-emails...', name: 'AUTH_REMOTE_DS');

      final docSnap = await firestore.collection('config').doc('participants-emails').get();
      if (docSnap.exists && docSnap.data() != null) {
        final data = docSnap.data()!;
        final rawEmails = data['emails'];
        if (rawEmails is List) {
          final isFound = rawEmails.any((e) => e.toString().trim().toLowerCase() == normalizedEmail);
          if (isFound) {
            dev.log('E-mail $normalizedEmail confirmé dans config/participants-emails (emails)', name: 'AUTH_REMOTE_DS');
            return true;
          }
        }
      }
    } catch (e, st) {
      dev.log('Erreur lors de la vérification dans config/participants-emails', name: 'AUTH_REMOTE_DS', error: e, stackTrace: st);
    }

    return false;
  }

  /// Recherche un document existant ou vérifie la liste de configuration des participants.
  Future<UserModel> _fetchAndSyncExistingUserDoc({
    required String firebaseUid,
    required String? email,
    required String? displayName,
    required String? googlePhotoUrl,
  }) async {
    QueryDocumentSnapshot<Map<String, dynamic>>? existingDoc;

    // 1. Recherche primaire : Document existant où email == user.email dans /users
    if (email != null && email.isNotEmpty) {
      final querySnap = await firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnap.docs.isNotEmpty) {
        existingDoc = querySnap.docs.first;
      }
    }

    // 2. Recherche secondaire : Document avec ID matching firebaseUid dans /users
    DocumentSnapshot<Map<String, dynamic>>? docByIdSnap;
    if (existingDoc == null) {
      final docSnap = await firestore.collection('users').doc(firebaseUid).get();
      if (docSnap.exists && docSnap.data() != null) {
        docByIdSnap = docSnap;
      }
    }

    final isParticipantInConfig = await _isEmailInParticipantsList(email ?? '');

    final docRefToUpdate = existingDoc != null
        ? existingDoc.reference
        : docByIdSnap?.reference;

    final data = existingDoc != null
        ? Map<String, dynamic>.from(existingDoc.data())
        : (docByIdSnap != null ? Map<String, dynamic>.from(docByIdSnap.data()!) : null);

    final docId = existingDoc != null
        ? existingDoc.id
        : (docByIdSnap != null ? docByIdSnap.id : firebaseUid);

    // Cas 1 : Le document utilisateur existe déjà dans /users
    if (data != null && docRefToUpdate != null) {
      final updates = <String, dynamic>{};

      // Si l'e-mail est dans la liste de configuration des participants et que le statut est en attente ou absent
      if (isParticipantInConfig && (data['status'] == 'pending' || data['status'] == 'not_found')) {
        dev.log('Validation automatique du statut utilisateur à "accepted" grâce à config/participants-emails', name: 'AUTH_REMOTE_DS');
        updates['status'] = 'accepted';
        data['status'] = 'accepted';
      }

      // Synchronisation photo de profil Google
      if (googlePhotoUrl != null && googlePhotoUrl.isNotEmpty) {
        if (data['photoUrl'] != googlePhotoUrl) {
          dev.log('Mise à jour photoUrl dans le document utilisateur ($docId)', name: 'AUTH_REMOTE_DS');
          updates['photoUrl'] = googlePhotoUrl;
          data['photoUrl'] = googlePhotoUrl;
        }
      }

      if (updates.isNotEmpty) {
        updates['updatedAt'] = FieldValue.serverTimestamp();
        await docRefToUpdate.update(updates);
      }

      dev.log('Document utilisateur synchronisé pour $email ($docId)', name: 'AUTH_REMOTE_DS');

      // Synchronisation asynchrone du token FCM
      try {
        if (sl.isRegistered<NotificationService>()) {
          sl<NotificationService>().syncUserFcmToken(docId);
        }
      } catch (e, st) {
        dev.log('Erreur lors du déclenchement syncUserFcmToken', name: 'AUTH_REMOTE_DS', error: e, stackTrace: st);
      }

      return UserModel.fromMap(data, docId);
    }

    // Cas 2 : Aucun document dans /users mais l'e-mail EST dans config/participants-emails
    if (isParticipantInConfig) {
      dev.log('Création du document initial pour le participant $email ($firebaseUid) avec statut accepted', name: 'AUTH_REMOTE_DS');
      final newUserData = <String, dynamic>{
        'name': displayName ?? 'Apprenant FFSC',
        'email': email ?? '',
        'role': 'student',
        'level': 1,
        'status': 'accepted',
        'totalPoints': 0,
        'photoUrl': googlePhotoUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await firestore.collection('users').doc(firebaseUid).set(newUserData);

      try {
        if (sl.isRegistered<NotificationService>()) {
          sl<NotificationService>().syncUserFcmToken(firebaseUid);
        }
      } catch (e, st) {
        dev.log('Erreur lors du déclenchement syncUserFcmToken', name: 'AUTH_REMOTE_DS', error: e, stackTrace: st);
      }

      return UserModel(
        id: firebaseUid,
        name: displayName ?? 'Apprenant FFSC',
        email: email ?? '',
        role: 'student',
        level: 1,
        status: 'accepted',
        totalPoints: 0,
        photoUrl: googlePhotoUrl,
        createdAt: DateTime.now().toIso8601String(),
      );
    }

    // Cas 3 : Non trouvé dans /users ET non trouvé dans config/participants-emails
    dev.log(
      'Aucun document Firestore trouvé et e-mail non autorisé ($email). Statut: not_found.',
      name: 'AUTH_REMOTE_DS',
    );
    return UserModel(
      id: firebaseUid,
      name: displayName ?? 'Apprenant FFSC',
      email: email ?? '',
      role: 'student',
      level: 1,
      status: 'not_found',
      photoUrl: googlePhotoUrl,
      createdAt: DateTime.now().toIso8601String(),
    );
  }

  @override
  Future<void> signOut() async {
    try {
      dev.log('Signing out user...', name: 'AUTH_REMOTE_DS');
      await googleSignIn.signOut();
      await firebaseAuth.signOut();
      dev.log('User signed out successfully', name: 'AUTH_REMOTE_DS');
    } catch (e, stackTrace) {
      dev.log('Error during signOut', name: 'AUTH_REMOTE_DS', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
