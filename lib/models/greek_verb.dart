import 'person.dart';
import 'verb_category.dart';

class VerbConjugation {
  final String greekForm;
  final String russianTranslation;
  final Person person;

  const VerbConjugation({
    required this.greekForm,
    required this.russianTranslation,
    required this.person,
  });
}

class GreekVerb {
  final String infinitive;
  final String russianTranslation;
  final VerbCategory category;
  final List<VerbConjugation> conjugations;
  final List<String>? alternativeEndings; // Для Γ1/Γ2 с двумя вариантами окончаний

  const GreekVerb({
    required this.infinitive,
    required this.russianTranslation,
    required this.category,
    required this.conjugations,
    this.alternativeEndings,
  });

  // Получить спряжение для конкретного лица
  VerbConjugation? getConjugationForPerson(Person person) {
    try {
      return conjugations.firstWhere((conj) => conj.person == person);
    } catch (e) {
      return null;
    }
  }

  // Получить все возможные формы для конкретного лица (включая альтернативные)
  List<String> getAllFormsForPerson(Person person) {
    final conjugation = getConjugationForPerson(person);
    if (conjugation == null) return [];
    
    List<String> forms = [conjugation.greekForm];
    
    // Добавляем альтернативные окончания для Γ1/Γ2
    if (alternativeEndings != null && alternativeEndings!.isNotEmpty) {
      forms.addAll(alternativeEndings!);
    }
    
    return forms;
  }
}
