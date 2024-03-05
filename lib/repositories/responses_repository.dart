import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_reviewer/blocs/reponses/responses_bloc.dart';
import 'package:mobile_reviewer/models/Responses.dart';
import 'package:mobile_reviewer/models/feedback.dart';
import 'package:mobile_reviewer/models/student_with_responses.dart';

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
      await _firestore
          .collection(collectionName)
          .doc(quizResponse.id)
          .set(quizResponse.toJson());
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

  Stream<List<QuizResponse>> getScoreByStudentID(String uid) {
    return _firestore
        .collection(collectionName)
        .where("studentID", isEqualTo: uid)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return QuizResponse.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<List<QuizResponse>> getScoreByTeacherID(String uid) {
    return _firestore
        .collection(collectionName)
        .where("teacherID", isEqualTo: uid)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return QuizResponse.fromJson(doc.data());
      }).toList();
    });
  }

  Future<void> addFeedback(String responseID, TeacherFeedBack feedback) {
    return _firestore
        .collection(collectionName)
        .doc(responseID)
        .update({"feedback": feedback.toJson()});
  }

  Stream<List<QuizResponse>> getFeedBack(String uid) {
    return _firestore
        .collection(collectionName)
        .where("studentID", isEqualTo: uid)
        .where("feedback", isNull: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return QuizResponse.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<List<StudentWithResponses>> getUserWithAssessments(String teacherID) {
    // Reference to the "users" collection
    CollectionReference usersRef = _firestore.collection("users");

    // Stream the users and their assessments
    return usersRef.snapshots().asyncMap((querySnapshot) async {
      List<StudentWithResponses> usersWithAssessments = [];

      // Loop through each user document
      for (var userDoc in querySnapshot.docs) {
        String userId = userDoc.id;

        Query assessmentsRef = _firestore
            .collection("quiz_responses")
            .where("teacherID", isEqualTo: teacherID)
            .orderBy("createdAt", descending: true);

        // Fetch the user's assessments
        QuerySnapshot assessmentsSnapshot = await assessmentsRef.get();
        List<QuizResponse> assessments = assessmentsSnapshot.docs.map((doc) {
          return QuizResponse.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
        print(userDoc.data());
        print(assessments);
        List<QuizResponse> filteredAssessments =
            assessments.where((e) => e.studentID == userId).toList();
        if (filteredAssessments.isNotEmpty) {
          filteredAssessments
              .sort((a, b) => b.createdAt.compareTo(a.createdAt));
          usersWithAssessments.add(
            StudentWithResponses(users: null, responses: []),
          );
        }
      }

      // Sort the usersWithAssessments list by the createdAt timestamp of the first assessment
      usersWithAssessments.sort((a, b) =>
          b.assesments[0].createdAt.compareTo(a.assesments[0].createdAt));

      return usersWithAssessments;
    });
  }
}
