import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:mobile_reviewer/models/users.dart';

class UserRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  late CollectionReference collectionReference;
  UserRepository({FirebaseFirestore? firestore, FirebaseStorage? storage})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance {
    collectionReference = _firestore.collection('users');
  }

  Future<void> addUser(Users user) async {
    await collectionReference.doc(user.id).set(user.toJson());
  }

  Future<void> updateUserProfile(Users users) async {
    await collectionReference
        .doc(users.id)
        .set(users.toJson(), SetOptions(merge: true));
  }

  Future<void> updateUserPhoto(String userID, String photoURL) async {
    await collectionReference.doc(userID).update({'photo': photoURL});
  }

  Stream<Users?> getUserByID(String uid) {
    return collectionReference.doc(uid).snapshots().map((docSnapshot) {
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        return Users.fromJson(data);
      } else {
        return null;
      }
    });
  }

  Future<void> deleteUserProfile(String userId) async {
    await collectionReference.doc(userId).delete();
  }

  Future<String?> uploadFile(File file) async {
    try {
      final Reference storageRef = _storage
          .ref()
          .child('users')
          .child('${DateTime.now().millisecondsSinceEpoch}');
      final UploadTask uploadTask = storageRef.putFile(file);
      await uploadTask.whenComplete(() => null);
      final imageUrl = await storageRef.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  Future<Users?> getUserInfo(String userID) async {
    try {
      final DocumentSnapshot userDoc =
          await collectionReference.doc(userID).get();
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        final Users user = Users.fromJson(data);
        return user;
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserFullname(String userID, String fullname) async {
    await collectionReference.doc(userID).update({'name': fullname});
  }
}
