import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_reviewer/models/Responses.dart';

class QuizResponseRepository {
  final FirebaseFirestore _firestore;
  final String collectionName = 'quiz_responses';
  late CollectionReference collectionReference;
  QuizResponseRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance {
    collectionReference = _firestore.collection('quiz');
  }
  Future<void> addQuizResponse(QuizResponse quizResponse) async {
    try {
      await _firestore.collection(collectionName).add(quizResponse.toJson());
    } catch (e) {
      print('Error adding quiz response: $e');
    }
  }

  Stream<List<QuizResponse>> getQuizResponses() {
    return _firestore.collection(collectionName).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return QuizResponse.fromJson(doc.data());
      }).toList();
    });
  }

  // Implement other CRUD methods as needed (e.g., updateQuizResponse, deleteQuizResponse).
}
