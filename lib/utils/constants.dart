// Regular expression for email validation
import '../models/answers.dart';
import '../models/questions.dart';

final RegExp emailRegex =
    RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

int calculateTotalScore(
    List<Questions> questionsList, List<Answer> answersList) {
  int totalScore = 0;

  Map<String, String> answersMap = Map.fromEntries(answersList.map(
      (answer) => MapEntry<String, String>(answer.questionID, answer.answer)));

  for (Questions question in questionsList) {
    // Check if the question's answer matches the provided answer
    if (answersMap.containsKey(question.id) &&
        answersMap[question.id] == question.answer) {
      totalScore += question.points;
    }
  }

  return totalScore;
}

int getTotalPoints(List<Questions> questions) {
  int total = 0;
  for (var e in questions) {
    total += e.points;
  }
  return total;
}
