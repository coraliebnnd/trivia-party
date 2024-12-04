import 'dart:convert';
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
          final _currentQuestion = decodeHtml(questionData['question']);
          final _correctAnswer = questionData['correct_answer'];
          final _answers = [
            ...(questionData['incorrect_answers'] as List<dynamic>),
            _correctAnswer
          ]..shuffle();

          final answerList = _answers
              .map((answer) => Answer(answer, answer == _correctAnswer))
              .toList();
          return QuestionAnswerPair(_currentQuestion, answerList);
        }
      } else {
        throw Exception('Failed to load question');
      }
    } catch (e) {
      print('Error fetching question: $e');
    }
    return null;
  }
}
