import 'person.dart';
import 'verb_category.dart';
import '../utils/greek_text_utils.dart';

enum QuestionType {
  greekToRussian,
  russianToGreek,
}

class QuizQuestion {
  final String question;
  final String correctAnswer;
  final List<String> allPossibleAnswers; // Все возможные правильные ответы
  final QuestionType type;
  final Person person;
  final VerbCategory category;

  const QuizQuestion({
    required this.question,
    required this.correctAnswer,
    required this.allPossibleAnswers,
    required this.type,
    required this.person,
    required this.category,
  });

  AnswerValidationResult validateAnswer(String answer) {
    if (type == QuestionType.greekToRussian) {
      // Для русских ответов используем валидацию с местоимениями
      return GreekTextUtils.validateRussianAnswer(answer, allPossibleAnswers);
    } else {
      // Для греческих ответов используем продвинутую валидацию
      return GreekTextUtils.validateAnswer(answer, allPossibleAnswers);
    }
  }

  // Обратная совместимость
  bool isCorrectAnswer(String answer) {
    return validateAnswer(answer).isCorrect;
  }
}
