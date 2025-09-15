import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;
import '../models/verb_category.dart';

class ProgressStorage {
  static const String _totalQuestionsKey = 'total_questions';
  static const String _correctAnswersKey = 'correct_answers';
  static const String _wrongAnswersKey = 'wrong_answers';
  static const String _targetQuestionsKey = 'target_questions';

  // Проверяем, работаем ли мы в веб-версии
  static bool get _isWeb {
    try {
      return html.window != null && html.window.localStorage != null;
    } catch (e) {
      return false;
    }
  }

  // Простое сохранение в localStorage и cookies
  static void _saveToLocalStorage(String key, int value) {
    if (_isWeb) {
      // Сохраняем в localStorage
      html.window.localStorage[key] = value.toString();
      
      // Также сохраняем в cookies как резерв
      html.document.cookie = '$key=$value; path=/; max-age=31536000'; // 1 год
    }
  }

  // Простая загрузка из localStorage и cookies
  static int _loadFromLocalStorage(String key, int defaultValue) {
    if (_isWeb) {
      // Сначала пробуем localStorage
      final value = html.window.localStorage[key];
      if (value != null) {
        final intValue = int.tryParse(value) ?? defaultValue;
        return intValue;
      }
      
      // Если в localStorage нет, пробуем cookies
      final cookieString = html.document.cookie;
      if (cookieString != null && cookieString.isNotEmpty) {
        final cookies = cookieString.split(';');
        for (final cookie in cookies) {
          final parts = cookie.trim().split('=');
          if (parts.length == 2 && parts[0] == key) {
            final intValue = int.tryParse(parts[1]) ?? defaultValue;
            return intValue;
          }
        }
      }
    }
    return defaultValue;
  }

  // Получить все ключи из localStorage и cookies
  static List<String> _getLocalStorageKeys() {
    if (_isWeb) {
      final localStorageKeys = html.window.localStorage.keys.toList();
      return localStorageKeys;
    }
    return [];
  }

  // Сохранить прогресс
  static Future<void> saveProgress({
    required int totalQuestions,
    required int correctAnswers,
    required int wrongAnswers,
    int targetQuestions = 100,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_totalQuestionsKey, totalQuestions);
    await prefs.setInt(_correctAnswersKey, correctAnswers);
    await prefs.setInt(_wrongAnswersKey, wrongAnswers);
    await prefs.setInt(_targetQuestionsKey, targetQuestions);
  }

  // Загрузить прогресс
  static Future<Map<String, int>> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'totalQuestions': prefs.getInt(_totalQuestionsKey) ?? 0,
      'correctAnswers': prefs.getInt(_correctAnswersKey) ?? 0,
      'wrongAnswers': prefs.getInt(_wrongAnswersKey) ?? 0,
      'targetQuestions': prefs.getInt(_targetQuestionsKey) ?? 100,
    };
  }

  // Сбросить прогресс
  static Future<void> resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_totalQuestionsKey);
    await prefs.remove(_correctAnswersKey);
    await prefs.remove(_wrongAnswersKey);
    await prefs.remove(_targetQuestionsKey);
  }

  // Сбросить прогресс для конкретной категории
  static Future<void> resetCategoryProgress(VerbCategory category) async {
    try {
      final categoryKey = '${category.code}_';
      
      if (_isWeb) {
        // Удаляем из localStorage и cookies
        html.window.localStorage.remove('${categoryKey}total');
        html.window.localStorage.remove('${categoryKey}correct');
        html.window.localStorage.remove('${categoryKey}wrong');
        html.window.localStorage.remove('${categoryKey}target');
        
        // Удаляем cookies
        html.document.cookie = '${categoryKey}total=; path=/; max-age=0';
        html.document.cookie = '${categoryKey}correct=; path=/; max-age=0';
        html.document.cookie = '${categoryKey}wrong=; path=/; max-age=0';
        html.document.cookie = '${categoryKey}target=; path=/; max-age=0';
      } else {
        // Удаляем из SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('${categoryKey}total');
        await prefs.remove('${categoryKey}correct');
        await prefs.remove('${categoryKey}wrong');
        await prefs.remove('${categoryKey}target');
      }
    } catch (e) {
      // Ошибка при сбросе прогресса категории
    }
  }

  // Получить прогресс для конкретной категории
  static Future<Map<String, int>> loadCategoryProgress(VerbCategory category) async {
    try {
      final categoryKey = '${category.code}_';
      
      Map<String, int> result;
      
      if (_isWeb) {
        // Используем localStorage для веб-версии
        result = {
          'totalQuestions': _loadFromLocalStorage('${categoryKey}total', 0),
          'correctAnswers': _loadFromLocalStorage('${categoryKey}correct', 0),
          'wrongAnswers': _loadFromLocalStorage('${categoryKey}wrong', 0),
          'targetQuestions': _loadFromLocalStorage('${categoryKey}target', 100),
        };
      } else {
        // Используем SharedPreferences для мобильных версий
        final prefs = await SharedPreferences.getInstance();
        result = {
          'totalQuestions': prefs.getInt('${categoryKey}total') ?? 0,
          'correctAnswers': prefs.getInt('${categoryKey}correct') ?? 0,
          'wrongAnswers': prefs.getInt('${categoryKey}wrong') ?? 0,
          'targetQuestions': prefs.getInt('${categoryKey}target') ?? 100,
        };
      }
      
      return result;
    } catch (e) {
      return {
        'totalQuestions': 0,
        'correctAnswers': 0,
        'wrongAnswers': 0,
        'targetQuestions': 100,
      };
    }
  }

  // Сохранить прогресс для конкретной категории
  static Future<void> saveCategoryProgress({
    required VerbCategory category,
    required int totalQuestions,
    required int correctAnswers,
    required int wrongAnswers,
    int targetQuestions = 100,
  }) async {
    try {
      final categoryKey = '${category.code}_';
      
      if (_isWeb) {
        // Используем localStorage для веб-версии
        _saveToLocalStorage('${categoryKey}total', totalQuestions);
        _saveToLocalStorage('${categoryKey}correct', correctAnswers);
        _saveToLocalStorage('${categoryKey}wrong', wrongAnswers);
        _saveToLocalStorage('${categoryKey}target', targetQuestions);
      } else {
        // Используем SharedPreferences для мобильных версий
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('${categoryKey}total', totalQuestions);
        await prefs.setInt('${categoryKey}correct', correctAnswers);
        await prefs.setInt('${categoryKey}wrong', wrongAnswers);
        await prefs.setInt('${categoryKey}target', targetQuestions);
      }
    } catch (e) {
      // Ошибка при сохранении прогресса
    }
  }
}