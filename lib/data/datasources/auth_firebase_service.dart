import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/auth/create_user_req.dart';
import '../models/auth/sign_in_user_req.dart';

abstract class AuthFirebaseService {
  Future<Either> signIn(SignInUserReq signInUserReq);
  Future<Either> register(CreateUserReq createUserReq);
  Future<Either> signInWithGoogle();
}

class AuthFirebaseServiceImpl implements AuthFirebaseService {
  @override
  Future<Either> signIn(SignInUserReq signInUserReq) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: signInUserReq.email,
        password: signInUserReq.password,
      );

      return const Right('User signed in successfully.');
    } on FirebaseAuthException catch (e) {
      String message = '';

      if (e.code == 'invalid-email') {
        message = 'No user found for that email.';
      } else if (e.code == 'invalid-credential') {
        message = 'Wrong password provided for that user.';
      }

      return Left(message);
    }
  }

  @override
  Future<Either> register(CreateUserReq createUserReq) async {
    try {
      var data = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: createUserReq.email,
        password: createUserReq.password,
      );

      // Save user data to Firestore
      FirebaseFirestore.instance.collection('Users').add(
        {
          'firstName': createUserReq.firstName,
          'lastName': createUserReq.lastName,
          'email': data.user?.email,
        },
      );

      return const Right('User created successfully.');
    } on FirebaseAuthException catch (e) {
      String message = '';

      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      }

      return Left(message);
    }
  }

  @override
  Future<Either> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return const Left('Google sign in was cancelled');

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // Save user data to Firestore if it's a new user
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        await FirebaseFirestore.instance.collection('Users').doc(userCredential.user?.uid).set({
          'firstName': googleUser.displayName?.split(' ').first,
          'lastName': googleUser.displayName?.split(' ').last,
          'email': googleUser.email,
        });
      }

      return const Right('Signed in with Google successfully');
    } catch (e) {
      return Left('Error signing in with Google: ${e.toString()}');
    }
  }
}