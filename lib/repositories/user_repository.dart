import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_reviewer/models/users.dart';

class UserRepository {
  final FirebaseFirestore _firestore;
  late CollectionReference collectionReference;
  UserRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance {
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

  Future<Users?> getUserProfile(String userId) async {
    final snapshot = await collectionReference.doc(userId).get();
    if (snapshot.exists) {
      return Users.fromJson(snapshot.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<void> deleteUserProfile(String userId) async {
    await collectionReference.doc(userId).delete();
  }
}
