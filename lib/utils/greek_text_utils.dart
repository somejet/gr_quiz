class GreekTextUtils {
  // Маппинг греческих букв с ударениями на буквы без ударений
  static const Map<String, String> _stressMap = {
    'ά': 'α', 'έ': 'ε', 'ή': 'η', 'ί': 'ι', 'ό': 'ο', 'ύ': 'υ', 'ώ': 'ω',
    'Ά': 'Α', 'Έ': 'Ε', 'Ή': 'Η', 'Ί': 'Ι', 'Ό': 'Ο', 'Ύ': 'Υ', 'Ώ': 'Ω',
    'ϊ': 'ι', 'ϋ': 'υ', 'Ϊ': 'Ι', 'Ϋ': 'Υ'
  };

  // Удаляет все ударения из греческого текста
  static String removeStresses(String text) {
    String result = text;
    _stressMap.forEach((stressed, unstressed) {
      result = result.replaceAll(stressed, unstressed);
    });
    return result;
  }

  // Проверяет, есть ли ударения в тексте
  static bool hasStresses(String text) {
    return _stressMap.keys.any((stressed) => text.contains(stressed));
  }

  // Сравнивает два греческих текста, игнорируя ударения
  static bool equalsIgnoringStresses(String text1, String text2) {
    return removeStresses(text1.toLowerCase().trim()) == 
           removeStresses(text2.toLowerCase().trim());
  }

  // Проверяет, отличается ли текст только ударениями
  static bool differsOnlyInStresses(String text1, String text2) {
    return equalsIgnoringStresses(text1, text2) && 
           hasStresses(text1) != hasStresses(text2);
  }

  // Генерирует сокращенные формы для греческих глаголов
  static List<String> generateShortForms(String fullForm) {
    List<String> shortForms = [fullForm];
    
    // Общие сокращения для греческих глаголов
    if (fullForm.endsWith('όσαστε')) {
      // κουραζόσαστε -> κουράζεστε
      String shortForm = fullForm.replaceAll('όσαστε', 'εστε');
      if (shortForm != fullForm) shortForms.add(shortForm);
    }
    
    if (fullForm.endsWith('όσατε')) {
      // κουραζόσατε -> κουράζετε
      String shortForm = fullForm.replaceAll('όσατε', 'ετε');
      if (shortForm != fullForm) shortForms.add(shortForm);
    }
    
    if (fullForm.endsWith('όμαστε')) {
      // κουραζόμαστε -> κουράζεστε
      String shortForm = fullForm.replaceAll('όμαστε', 'εστε');
      if (shortForm != fullForm) shortForms.add(shortForm);
    }
    
    if (fullForm.endsWith('όματε')) {
      // κουραζόματε -> κουράζετε
      String shortForm = fullForm.replaceAll('όματε', 'ετε');
      if (shortForm != fullForm) shortForms.add(shortForm);
    }

    // Специфичные случаи для разных категорий глаголов
    if (fullForm.endsWith('άω')) {
      // μιλάω -> μιλώ (сокращенная форма)
      String shortForm = fullForm.replaceAll('άω', 'ώ');
      if (shortForm != fullForm) shortForms.add(shortForm);
    }
    
    if (fullForm.endsWith('άς')) {
      // μιλάς -> μιλείς
      String shortForm = fullForm.replaceAll('άς', 'είς');
      if (shortForm != fullForm) shortForms.add(shortForm);
    }
    
    if (fullForm.endsWith('άει')) {
      // μιλάει -> μιλεί
      String shortForm = fullForm.replaceAll('άει', 'εί');
      if (shortForm != fullForm) shortForms.add(shortForm);
    }
    
    if (fullForm.endsWith('άμε')) {
      // μιλάμε -> μιλούμε
      String shortForm = fullForm.replaceAll('άμε', 'ούμε');
      if (shortForm != fullForm) shortForms.add(shortForm);
    }
    
    if (fullForm.endsWith('άτε')) {
      // μιλάτε -> μιλείτε
      String shortForm = fullForm.replaceAll('άτε', 'είτε');
      if (shortForm != fullForm) shortForms.add(shortForm);
    }
    
    if (fullForm.endsWith('άνε')) {
      // μιλάνε -> μιλούν
      String shortForm = fullForm.replaceAll('άνε', 'ούν');
      if (shortForm != fullForm) shortForms.add(shortForm);
    }

    // Добавляем варианты с разными ударениями
    List<String> variantsWithStresses = [];
    for (String form in shortForms) {
      variantsWithStresses.addAll(_generateStressVariants(form));
    }
    
    return [...shortForms, ...variantsWithStresses].toSet().toList();
  }

  // Генерирует варианты с разными ударениями
  static List<String> _generateStressVariants(String form) {
    List<String> variants = [];
    
    // Простые замены ударений
    Map<String, String> stressReplacements = {
      'α': 'ά', 'ε': 'έ', 'η': 'ή', 'ι': 'ί', 'ο': 'ό', 'υ': 'ύ', 'ω': 'ώ'
    };
    
    for (String letter in stressReplacements.keys) {
      if (form.contains(letter)) {
        String variant = form.replaceFirst(letter, stressReplacements[letter]!);
        if (variant != form) variants.add(variant);
      }
    }
    
    return variants;
  }

  // Проверяет валидность греческого ответа
  static AnswerValidationResult validateAnswer(String userAnswer, List<String> correctAnswers) {
    // Точное совпадение
    for (String correct in correctAnswers) {
      if (userAnswer.toLowerCase().trim() == correct.toLowerCase().trim()) {
        return AnswerValidationResult.correct();
      }
    }

    // Проверка сокращенных форм
    for (String correct in correctAnswers) {
      List<String> allPossibleForms = generateShortForms(correct);
      for (String form in allPossibleForms) {
        if (userAnswer.toLowerCase().trim() == form.toLowerCase().trim()) {
          return AnswerValidationResult.correct();
        }
      }
    }

    // Проверка на различие только в ударениях
    for (String correct in correctAnswers) {
      if (equalsIgnoringStresses(userAnswer, correct)) {
        return AnswerValidationResult.stressWarning('Правильно, но обратите внимание на ударение');
      }
    }

    // Проверка сокращенных форм с игнорированием ударений
    for (String correct in correctAnswers) {
      List<String> allPossibleForms = generateShortForms(correct);
      for (String form in allPossibleForms) {
        if (equalsIgnoringStresses(userAnswer, form)) {
          return AnswerValidationResult.stressWarning('Правильно, но обратите внимание на ударение');
        }
      }
    }

    return AnswerValidationResult.incorrect();
  }

  // Нормализует русский текст (заменяет ё на е)
  static String normalizeRussianText(String text) {
    return text.replaceAll('ё', 'е').replaceAll('Ё', 'Е');
  }

  // Проверяет валидность русского ответа (с поддержкой местоимений и ё/е)
  static AnswerValidationResult validateRussianAnswer(String userAnswer, List<String> correctAnswers) {
    String normalizedUserAnswer = normalizeRussianText(userAnswer.toLowerCase().trim());
    
    // Точное совпадение
    for (String correct in correctAnswers) {
      String normalizedCorrect = normalizeRussianText(correct.toLowerCase().trim());
      if (normalizedUserAnswer == normalizedCorrect) {
        return AnswerValidationResult.correct();
      }
    }

    // Проверка с местоимениями
    for (String correct in correctAnswers) {
      List<String> variantsWithPronouns = generateRussianVariants(correct);
      for (String variant in variantsWithPronouns) {
        String normalizedVariant = normalizeRussianText(variant.toLowerCase().trim());
        if (normalizedUserAnswer == normalizedVariant) {
          return AnswerValidationResult.correct();
        }
      }
    }

    return AnswerValidationResult.incorrect();
  }

  // Генерирует варианты русского ответа с местоимениями
  static List<String> generateRussianVariants(String baseAnswer) {
    List<String> variants = [baseAnswer];
    
    // Добавляем местоимения для разных лиц
    Map<String, List<String>> pronouns = {
      'я': ['я', 'Я'],
      'ты': ['ты', 'Ты'],
      'он': ['он', 'Он'],
      'она': ['она', 'Она'],
      'оно': ['оно', 'Оно'],
      'мы': ['мы', 'Мы'],
      'вы': ['вы', 'Вы'],
      'они': ['они', 'Они'],
    };

    // Добавляем варианты с местоимениями перед глаголом
    for (String pronoun in pronouns.keys) {
      variants.add('$pronoun $baseAnswer');
      variants.add('${pronouns[pronoun]![1]} $baseAnswer'); // Заглавная буква
    }

    // Добавляем варианты с местоимениями после глагола
    for (String pronoun in pronouns.keys) {
      variants.add('$baseAnswer $pronoun');
      variants.add('$baseAnswer ${pronouns[pronoun]![1]}'); // Заглавная буква
    }

    return variants.toSet().toList();
  }
}

class AnswerValidationResult {
  final bool isCorrect;
  final bool isStressWarning;
  final String? message;

  AnswerValidationResult._({
    required this.isCorrect,
    required this.isStressWarning,
    this.message,
  });

  factory AnswerValidationResult.correct() {
    return AnswerValidationResult._(
      isCorrect: true,
      isStressWarning: false,
    );
  }

  factory AnswerValidationResult.stressWarning(String message) {
    return AnswerValidationResult._(
      isCorrect: false,
      isStressWarning: true,
      message: message,
    );
  }

  factory AnswerValidationResult.incorrect() {
    return AnswerValidationResult._(
      isCorrect: false,
      isStressWarning: false,
    );
  }
}
