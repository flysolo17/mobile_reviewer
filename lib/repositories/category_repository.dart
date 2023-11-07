import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mobile_reviewer/models/categories.dart';

class CategoryRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  late CollectionReference collectionReference;
  List<Categories> _categories = [];
  
  CategoryRepository({FirebaseFirestore? firestore, FirebaseStorage? storage})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance {
    collectionReference = _firestore.collection('categories');
  }

  Stream<List<Categories>> getCategoriesStream() {
    return _firestore
        .collection('categories')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
      return snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
        return Categories.fromJson(doc.data() ?? {});
      }).toList();
    });
  }

  void setCategories(List<Categories> list) {
    _categories = list;
  }

  List<Categories> getCategories() {
    return _categories;
  }

  Future<void> addCategory(Categories category) async {
    category.id = collectionReference.doc().id;
    await collectionReference.doc(category.id).set(category.toJson());
  }

  Future<String?> uploadFile(File file) async {
    try {
      final Reference storageRef = _storage
          .ref()
          .child('categories')
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
}
