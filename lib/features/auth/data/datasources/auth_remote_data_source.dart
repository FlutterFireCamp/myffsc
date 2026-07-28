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
      final authClient = googleUser.authorizationClient;
      final clientAuth = await authClient.authorizationForScopes([]);

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: clientAuth?.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await firebaseAuth.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        dev.log('Firebase User is null after credential sign-in', name: 'AUTH_REMOTE_DS');
        throw Exception("Échec de la récupération de l'utilisateur Firebase.");
      }

      // Fetch user document from Firestore 'users' collection
      final docRef = firestore.collection('users').doc(firebaseUser.uid);
      final docSnap = await docRef.get();

      final googlePhotoUrl = firebaseUser.photoURL ?? googleUser.photoUrl;

      if (docSnap.exists && docSnap.data() != null) {
        final data = Map<String, dynamic>.from(docSnap.data()!);

        // Sync Google photoUrl to Firestore document if present and missing/different
        if (googlePhotoUrl != null && googlePhotoUrl.isNotEmpty) {
          if (data['photoUrl'] != googlePhotoUrl) {
            dev.log('Updating user photoUrl in Firestore to: $googlePhotoUrl', name: 'AUTH_REMOTE_DS');
            await docRef.update({'photoUrl': googlePhotoUrl});
            data['photoUrl'] = googlePhotoUrl;
          }
        }

        dev.log('Fetched existing user doc for UID: ${firebaseUser.uid}', name: 'AUTH_REMOTE_DS');
        return UserModel.fromMap(data, firebaseUser.uid);
      } else {
        dev.log('User doc not found. Creating new user doc for UID: ${firebaseUser.uid}', name: 'AUTH_REMOTE_DS');
        final newUser = UserModel(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? googleUser.displayName ?? 'Apprenant FFSC',
          email: firebaseUser.email ?? googleUser.email,
          role: 'student',
          level: 1,
          status: 'pending', // Requires admin approval
          photoUrl: googlePhotoUrl,
          createdAt: DateTime.now().toIso8601String(),
        );
        await docRef.set(newUser.toMap());
        return newUser;
      }
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

      final docRef = firestore.collection('users').doc(firebaseUser.uid);
      final docSnap = await docRef.get();

      final googlePhotoUrl = firebaseUser.photoURL;

      if (docSnap.exists && docSnap.data() != null) {
        final data = Map<String, dynamic>.from(docSnap.data()!);

        if (googlePhotoUrl != null && googlePhotoUrl.isNotEmpty) {
          if (data['photoUrl'] != googlePhotoUrl) {
            dev.log('Syncing updated Google photoUrl for UID: ${firebaseUser.uid}', name: 'AUTH_REMOTE_DS');
            await docRef.update({'photoUrl': googlePhotoUrl});
            data['photoUrl'] = googlePhotoUrl;
          }
        }

        dev.log('Successfully fetched current user doc: ${firebaseUser.uid}', name: 'AUTH_REMOTE_DS');
        return UserModel.fromMap(data, firebaseUser.uid);
      } else {
        dev.log('User doc missing in Firestore for current auth user: ${firebaseUser.uid}', name: 'AUTH_REMOTE_DS');
        return UserModel(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? 'Apprenant FFSC',
          email: firebaseUser.email ?? '',
          role: 'student',
          level: 1,
          status: 'pending',
          photoUrl: googlePhotoUrl,
        );
      }
    } catch (e, stackTrace) {
      dev.log('Error fetching getCurrentUser', name: 'AUTH_REMOTE_DS', error: e, stackTrace: stackTrace);
      rethrow;
    }
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
