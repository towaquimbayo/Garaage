import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:garaage/domain/entities/user.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/error/failures.dart';
import '../models/auth/create_user_req.dart';
import '../models/auth/sign_in_user_req.dart';

abstract class AuthFirebaseService {
  Future<Either> signIn(SignInUserReq signInUserReq);

  Future<Either> register(CreateUserReq createUserReq);

  Future<Either> signInWithGoogle();

  Future<Either> signOut();

  Future<Either> getUser();
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
      String type = 'error';
      String message = '';

      if (e.code == 'channel-error') {
        message = 'One or more of the fields are empty.';
      } else if (e.code == 'network-request-failed') {
        message = 'No internet connection.';
      } else if (e.code == 'invalid-email') {
        message = 'No user found for that email.';
      } else if (e.code == 'invalid-credential') {
        message = 'Wrong password provided for that user.';
      }

      return Left(ServerFailure(type, message));
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
      FirebaseFirestore.instance.collection('Users').doc(data.user?.uid).set(
        {
          'firstName': createUserReq.firstName,
          'lastName': createUserReq.lastName,
          'email': data.user?.email,
        },
      );

      return const Right('User created successfully.');
    } on FirebaseAuthException catch (e) {
      String type = 'error';
      String message = '';

      if (e.code == 'channel-error') {
        message = 'One or more of the fields are empty.';
      } else if (e.code == 'network-request-failed') {
        message = 'No internet connection.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is badly formatted.';
      } else if (e.code == 'weak-password') {
        message = 'Password should be at least 6 characters.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      }

      return Left(ServerFailure(type, message));
    }
  }

  @override
  Future<Either> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null)
        throw FirebaseAuthException(code: 'google-sign-in-failed');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Save user data to Firestore if it's a new user
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        print("User_______________________");
        print(userCredential.user);
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userCredential.user?.uid)
            .set({
          'firstName': googleUser.displayName?.split(' ').first,
          'lastName': googleUser.displayName?.split(' ').last,
          'email': googleUser.email,
          'imageUrl': googleUser.photoUrl,
        });
      }

      return const Right('Signed in with Google successfully');
    } on FirebaseAuthException catch (e) {
      String type = 'error';
      String message = '';

      if (e.code == 'network-request-failed') {
        message = 'No internet connection.';
      } else if (e.code == 'google-sign-in-failed') {
        message = 'Google sign in was cancelled.';
      }

      return Left(ServerFailure(type, message));
    } catch (e) {
      return Left(ServerFailure("error", "An unexpected error occurred."));
    }
  }

  @override
  Future<Either> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();

      return const Right('User signed out successfully.');
    } catch (e) {
      return Left(
          ServerFailure('error', 'An error occurred while signing out.'));
    }
  }

  @override
  Future<Either> getUser() async {
    try {
      final currentFireBaseUser = FirebaseAuth.instance.currentUser;
      if (currentFireBaseUser == null) throw Exception("Current user is null");
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentFireBaseUser.uid)
          .get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        final localUser = UserEntity(
          firstName: userData['firstName'],
          lastName: userData['lastName'],
          email: userData['email'],
          imageUrl: userData['imageUrl'],
        );
        return Left(localUser);
      } else {
        throw Exception("User doc does not exist");
      }
    } catch (e) {
      return Right(
        ServerFailure(
            "error", 'An error occurred while getting user information.'),
      );
    }
  }
}
