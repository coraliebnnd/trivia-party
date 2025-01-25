/* We found out, that sometimes, the api server can get fed up with too many requests
and responds with 429. We use canned questions to fake questions loaded from
the api in that case
 */

import 'dart:math';

import 'package:trivia_party/networking/question_loader.dart';

import 'canned_questions.dart';

QuestionAnswerPair loadCannedQuestion(int categoryId) {
  if (categoryId == 14) {
    categoryId = 11;
  }
  List<QuestionAnswerPair>? questionAnswerPairs =
      categoryCannedQuestionMap[categoryId];
  if (questionAnswerPairs != null) {
    return pickRandomQuestionFromList(questionAnswerPairs);
  }
  return QuestionAnswerPair("", []);
}

QuestionAnswerPair pickRandomQuestionFromList(
    List<QuestionAnswerPair> questionAnswerPairs) {
  // Create a random number generator
  Random random = Random();

  // Pick a random element
  QuestionAnswerPair randomElement =
      questionAnswerPairs[random.nextInt(questionAnswerPairs.length)];
  return randomElement;
}
