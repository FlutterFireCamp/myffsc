import 'dart:developer' as dev;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  /// Finds an existing user document where `email == user.email` (or docId == firebaseUid).
  /// Updates only `photoUrl` if changed and returns the UserModel.
  /// Never creates a new document in Firestore.
  Future<UserModel> _fetchAndSyncExistingUserDoc({
    required String firebaseUid,
    required String? email,
    required String? displayName,
    required String? googlePhotoUrl,
  }) async {
    QueryDocumentSnapshot<Map<String, dynamic>>? existingDoc;

    // 1. Primary search: Query Firestore for existing document where email == user.email
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

    // 2. Secondary search: Check doc with ID matching firebaseUid
    DocumentSnapshot<Map<String, dynamic>>? docByIdSnap;
    if (existingDoc == null) {
      final docSnap = await firestore.collection('users').doc(firebaseUid).get();
      if (docSnap.exists && docSnap.data() != null) {
        docByIdSnap = docSnap;
      }
    }

    final docRefToUpdate = existingDoc != null
        ? existingDoc.reference
        : docByIdSnap?.reference;

    final data = existingDoc != null
        ? Map<String, dynamic>.from(existingDoc.data())
        : (docByIdSnap != null ? Map<String, dynamic>.from(docByIdSnap.data()!) : null);

    final docId = existingDoc != null
        ? existingDoc.id
        : (docByIdSnap != null ? docByIdSnap.id : firebaseUid);

    if (data != null && docRefToUpdate != null) {
      // Sync photoUrl if present and changed
      if (googlePhotoUrl != null && googlePhotoUrl.isNotEmpty) {
        if (data['photoUrl'] != googlePhotoUrl) {
          dev.log('Updating photoUrl in existing user doc ($docId) to $googlePhotoUrl', name: 'AUTH_REMOTE_DS');
          await docRefToUpdate.update({'photoUrl': googlePhotoUrl});
          data['photoUrl'] = googlePhotoUrl;
        }
      }

      dev.log('Found existing user doc for email ($email) / docId ($docId)', name: 'AUTH_REMOTE_DS');
      return UserModel.fromMap(data, docId);
    }

    // 3. If NO document exists in Firestore for this email/UID:
    // DO NOT create a new document in Firestore per user requirements.
    dev.log(
      'No pre-existing Firestore document found for email: $email. Returning unapproved user state (not_found) without creating Firestore doc.',
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
