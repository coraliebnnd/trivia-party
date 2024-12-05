import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';
import 'package:trivia_party/bloc/game_event.dart';

class QuestionAnswerPair {
  String question;
  List<Answer> answers;
  QuestionAnswerPair(this.question, this.answers);
}

class QuestionLoader {
  static String decodeHtml(String html) {
    final unescape = HtmlUnescape();
    return unescape.convert(html);
  }

  static Future<QuestionAnswerPair?> loadQuestion() async {
    const url =
        'https://opentdb.com/api.php?amount=1&category=10&type=multiple';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Parse the question and answers
        if (data['results'] != null && data['results'].isNotEmpty) {
          final questionData = data['results'][0];
          final currentQuestion = decodeHtml(questionData['question']);
          final correctAnswer = questionData['correct_answer'];
          final answers = [
            ...(questionData['incorrect_answers'] as List<dynamic>),
            correctAnswer
          ]..shuffle();

          final answerList = answers
              .map((answer) => Answer(answer, answer == correctAnswer))
              .toList();
          return QuestionAnswerPair(currentQuestion, answerList);
        }
      } else {
        throw Exception('Failed to load question');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching question: $e');
      }
    }
    return null;
  }
}
