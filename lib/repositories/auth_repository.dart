import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  User? get currentUser => _auth.currentUser;
  AuthRepository({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;
  Future<User?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      var result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<User?> registerWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'password-too-weak') {
        throw Exception("Your password too weak!");
      } else if (e.code == 'email-already-in-use') {
        throw Exception("Email is already in use!");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    return null;
  }

  Future resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User> reAuthenticateUser(User user, String currentPassword) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!, password: currentPassword);
      await user.reauthenticateWithCredential(credential);
      return user;
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> changePassword(User user, String newPassword) async {
    try {
      await user.updatePassword(newPassword);
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  // Future<String?> uploadImageToFirebaseStorage(
  //     File imageFile, String fileName) async {
  //   try {

  //     // Create a reference to the Firebase Storage bucket
  //     final Reference storageReference =
  //         FirebaseStorage.instance.ref().child(fileName);

  //     // Upload the image file to Firebase Storage
  //     final UploadTask uploadTask = storageReference.putFile(imageFile);

  //     // Wait for the upload to complete and get the download URL
  //     final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});

  //     // Get the download URL of the uploaded image
  //     final String imageUrl = await taskSnapshot.ref.getDownloadURL();

  //     return imageUrl;
  //   } catch (error) {
  //     print("Error uploading image: $error");
  //     return null;
  //   }
  // }
}
