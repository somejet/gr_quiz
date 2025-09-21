import 'dart:math';
import '../models/greek_verb.dart';
import '../models/person.dart';
import '../models/verb_category.dart';
import '../models/quiz_question.dart';
import '../data/all_verb_data.dart';
import 'greek_text_utils.dart';

class QuizGenerator {
  static final Random _random = Random();

  static List<QuizQuestion> generateQuestions(VerbCategory category, int count) {
    List<GreekVerb> verbs;
    
    if (category == VerbCategory.daily) {
      verbs = AllVerbData.getDailyVerbs();
    } else {
      verbs = AllVerbData.getVerbsByCategory(category);
    }
    
    final questions = <QuizQuestion>[];

    for (int i = 0; i < count; i++) {
      final verb = verbs[_random.nextInt(verbs.length)];
      final person = Person.values[_random.nextInt(Person.values.length)];
      final questionType = _random.nextBool() 
          ? QuestionType.greekToRussian 
          : QuestionType.russianToGreek;

      final conjugation = verb.getConjugationForPerson(person);
      if (conjugation == null) continue;

      QuizQuestion question;
      if (questionType == QuestionType.greekToRussian) {
        // Генерируем варианты русского ответа с местоимениями
        List<String> allPossibleAnswers = GreekTextUtils.generateRussianVariants(conjugation.russianTranslation);
        
        question = QuizQuestion(
          question: conjugation.greekForm,
          correctAnswer: conjugation.russianTranslation,
          allPossibleAnswers: allPossibleAnswers,
          type: questionType,
          person: person,
          category: category,
        );
      } else {
        // Генерируем все возможные формы включая сокращенные
        List<String> allPossibleAnswers = verb.getAllFormsForPerson(person);
        List<String> shortForms = GreekTextUtils.generateShortForms(conjugation.greekForm);
        allPossibleAnswers.addAll(shortForms);
        
        question = QuizQuestion(
          question: '${conjugation.russianTranslation} (${person.russianPronoun})',
          correctAnswer: conjugation.greekForm,
          allPossibleAnswers: allPossibleAnswers.toSet().toList(),
          type: questionType,
          person: person,
          category: category,
        );
      }

      questions.add(question);
    }

    return questions;
  }

  static QuizQuestion generateRandomQuestion(VerbCategory category) {
    List<GreekVerb> verbs;
    
    if (category == VerbCategory.daily) {
      verbs = AllVerbData.getDailyVerbs();
    } else {
      verbs = AllVerbData.getVerbsByCategory(category);
    }
    
    final verb = verbs[_random.nextInt(verbs.length)];
    final person = Person.values[_random.nextInt(Person.values.length)];
    final questionType = _random.nextBool() 
        ? QuestionType.greekToRussian 
        : QuestionType.russianToGreek;

    final conjugation = verb.getConjugationForPerson(person);
    if (conjugation == null) {
      return generateRandomQuestion(category); // Рекурсивно генерируем новый вопрос
    }

    if (questionType == QuestionType.greekToRussian) {
      // Генерируем варианты русского ответа с местоимениями
      List<String> allPossibleAnswers = GreekTextUtils.generateRussianVariants(conjugation.russianTranslation);
      
      return QuizQuestion(
        question: conjugation.greekForm,
        correctAnswer: conjugation.russianTranslation,
        allPossibleAnswers: allPossibleAnswers,
        type: questionType,
        person: person,
        category: category,
      );
    } else {
      // Генерируем все возможные формы включая сокращенные
      List<String> allPossibleAnswers = verb.getAllFormsForPerson(person);
      List<String> shortForms = GreekTextUtils.generateShortForms(conjugation.greekForm);
      allPossibleAnswers.addAll(shortForms);
      
      return QuizQuestion(
        question: '${conjugation.russianTranslation} (${person.russianPronoun})',
        correctAnswer: conjugation.greekForm,
        allPossibleAnswers: allPossibleAnswers.toSet().toList(),
        type: questionType,
        person: person,
        category: category,
      );
    }
  }
}
