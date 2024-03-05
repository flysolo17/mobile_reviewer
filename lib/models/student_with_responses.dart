import 'package:mobile_reviewer/models/Responses.dart';
import 'package:mobile_reviewer/models/users.dart';

class StudentWithResponses {
  Users users;
  List<QuizResponse> responses;

  StudentWithResponses({required this.users, required this.responses});
}
