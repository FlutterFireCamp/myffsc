import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithGoogle();
  Future<UserModel?> getCurrentUser();
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.googleSignIn,
    required this.firestore,
  });

  @override
  Future<UserModel> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception("Connexion Google annulée par l'utilisateur.");
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential = await firebaseAuth.signInWithCredential(credential);
    final User? firebaseUser = userCredential.user;

    if (firebaseUser == null) {
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
          await docRef.update({'photoUrl': googlePhotoUrl});
          data['photoUrl'] = googlePhotoUrl;
        }
      }

      return UserModel.fromMap(data, firebaseUser.uid);
    } else {
      // If user document does not exist yet, create default pending profile with Google photoUrl
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
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final firebaseUser = firebaseAuth.currentUser;
    if (firebaseUser == null) return null;

    final docRef = firestore.collection('users').doc(firebaseUser.uid);
    final docSnap = await docRef.get();

    final googlePhotoUrl = firebaseUser.photoURL;

    if (docSnap.exists && docSnap.data() != null) {
      final data = Map<String, dynamic>.from(docSnap.data()!);

      // Sync Google photoUrl to Firestore if available and missing
      if (googlePhotoUrl != null && googlePhotoUrl.isNotEmpty) {
        if (data['photoUrl'] != googlePhotoUrl) {
          await docRef.update({'photoUrl': googlePhotoUrl});
          data['photoUrl'] = googlePhotoUrl;
        }
      }

      return UserModel.fromMap(data, firebaseUser.uid);
    } else {
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
  }

  @override
  Future<void> signOut() async {
    await googleSignIn.signOut();
    await firebaseAuth.signOut();
  }
}
