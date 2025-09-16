import 'package:flutter/material.dart';
import '../models/verb_category.dart';
import '../models/greek_verb.dart';
import '../models/person.dart';

class ConjugationRulesScreen extends StatelessWidget {
  final VerbCategory category;
  final GreekVerb? currentVerb;

  const ConjugationRulesScreen({
    super.key, 
    required this.category,
    this.currentVerb,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        title: Text(
          'Правила спряжения ${category.code}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Описание категории
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF2D2D44),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        category.code,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      category.description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Правила спряжения
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF2D2D44),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Правила спряжения:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _getConjugationRules(),
                    style: const TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Пример с текущим глаголом
            if (currentVerb != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A2E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF2D2D44),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Пример: ${currentVerb!.infinitive} (${currentVerb!.russianTranslation})',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...currentVerb!.conjugations.map((conjugation) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 80,
                              child: Text(
                                _getPersonLabel(conjugation.person),
                                style: const TextStyle(
                                  color: Color(0xFF9CA3AF),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                conjugation.greekForm,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                conjugation.russianTranslation,
                                style: const TextStyle(
                                  color: Color(0xFF9CA3AF),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getConjugationRules() {
    switch (category) {
      case VerbCategory.a:
        return '''• Безударная основа -ω
• Окончания: -ω, -εις, -ει, -ουμε, -ετε, -ουν
• Основа остается неизменной во всех формах
• Пример: κάνω → κάνω, κάνεις, κάνει, κάνουμε, κάνετε, κάνουν''';
      
      case VerbCategory.b1:
        return '''• Основа на -άω
• Окончания: -άω, -άς, -άει, -άμε, -άτε, -άνε
• Ударение падает на -ά во всех формах
• Пример: αγαπάω → αγαπάω, αγαπάς, αγαπάει, αγαπάμε, αγαπάτε, αγαπάνε''';
      
      case VerbCategory.b2:
        return '''• Основа на -ώ
• Окончания: -ώ, -είς, -εί, -ούμε, -είτε, -ούν
• Ударение падает на -ώ в 1-м лице единственного числа
• Пример: αργώ → αργώ, αργείς, αργεί, αργούμε, αργείτε, αργούν''';
      
      case VerbCategory.ab:
        return '''• Смешанная категория
• Сочетает особенности категорий A и B
• Окончания могут варьироваться в зависимости от глагола
• Требует запоминания конкретных форм''';
      
      case VerbCategory.gamma1:
        return '''• Возвратные глаголы на -ομαι
• Окончания: -ομαι, -εσαι, -εται, -όμαστε, -εστε, -ονται
• Пример: βρίσκομαι → βρίσκομαι, βρίσκεσαι, βρίσκεται, βρισκόμαστε, βρίσκεστε, βρίσκονται''';
      
      case VerbCategory.gamma2:
        return '''• Возвратные глаголы на -αμαι
• Окончания: -αμαι, -ασαι, -αται, -άμαστε, -αστε, -ανται
• Пример: χρειάζομαι → χρειάζομαι, χρειάζεσαι, χρειάζεται, χρειαζόμαστε, χρειάζεστε, χρειάζονται''';
    }
  }

  String _getPersonLabel(Person person) {
    switch (person) {
      case Person.firstSingular:
        return 'Я';
      case Person.secondSingular:
        return 'Ты';
      case Person.thirdSingular:
        return 'Он/Она';
      case Person.firstPlural:
        return 'Мы';
      case Person.secondPlural:
        return 'Вы';
      case Person.thirdPlural:
        return 'Они';
    }
  }
}
