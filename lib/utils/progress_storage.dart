import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/verb_category.dart';
import '../data/all_verb_data.dart';

class ProgressStorage {
  static const String _totalQuestionsKey = 'total_questions';
  static const String _correctAnswersKey = 'correct_answers';
  static const String _wrongAnswersKey = 'wrong_answers';
  static const String _targetQuestionsKey = 'target_questions';

  // Проверяем, работаем ли мы в веб-версии
  static bool get _isWeb {
    try {
      // Используем kIsWeb из Flutter для надежного определения
      final isWeb = kIsWeb;
      print('Определение платформы (kIsWeb): isWeb = $isWeb');
      return isWeb;
    } catch (e) {
      print('Ошибка при определении веб-платформы: $e');
      return false;
    }
  }

  // Проверяем, работаем ли мы на мобильной платформе
  static bool get _isMobile {
    try {
      // Если мы не в веб-версии, значит на мобильной платформе
      final isMobile = !_isWeb;
      print('Определение платформы: isMobile = $isMobile');
      return isMobile;
    } catch (e) {
      print('Ошибка при определении мобильной платформы: $e');
      return true; // По умолчанию считаем мобильной платформой
    }
  }

  // Получить путь к файлу для сохранения прогресса
  static Future<String> _getProgressFilePath(String categoryCode) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      return '${directory.path}/progress_${categoryCode}.json';
    } catch (e) {
      print('Ошибка при получении пути к файлу: $e');
      return '';
    }
  }

  // Сохранить прогресс в файл
  static Future<void> _saveToFile(String categoryCode, Map<String, int> progress) async {
    try {
      final filePath = await _getProgressFilePath(categoryCode);
      if (filePath.isNotEmpty) {
        final file = File(filePath);
        await file.writeAsString(jsonEncode(progress));
        print('Прогресс сохранен в файл: $filePath');
      }
    } catch (e) {
      print('Ошибка при сохранении в файл: $e');
    }
  }

  // Загрузить прогресс из файла
  static Future<Map<String, int>> _loadFromFile(String categoryCode) async {
    try {
      final filePath = await _getProgressFilePath(categoryCode);
      if (filePath.isNotEmpty) {
        final file = File(filePath);
        if (await file.exists()) {
          final content = await file.readAsString();
          final progress = jsonDecode(content) as Map<String, dynamic>;
          final result = {
            'totalQuestions': progress['totalQuestions'] as int? ?? 0,
            'correctAnswers': progress['correctAnswers'] as int? ?? 0,
            'wrongAnswers': progress['wrongAnswers'] as int? ?? 0,
            'targetQuestions': progress['targetQuestions'] as int? ?? 100,
          };
          print('Прогресс загружен из файла: $filePath');
          return result;
        }
      }
    } catch (e) {
      print('Ошибка при загрузке из файла: $e');
    }
    return {
      'totalQuestions': 0,
      'correctAnswers': 0,
      'wrongAnswers': 0,
      'targetQuestions': 100,
    };
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
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_totalQuestionsKey, totalQuestions);
      await prefs.setInt(_correctAnswersKey, correctAnswers);
      await prefs.setInt(_wrongAnswersKey, wrongAnswers);
      await prefs.setInt(_targetQuestionsKey, targetQuestions);
      print('Общий прогресс сохранен: total=$totalQuestions, correct=$correctAnswers, wrong=$wrongAnswers');
    } catch (e) {
      print('Ошибка при сохранении общего прогресса: $e');
    }
  }

  // Загрузить прогресс
  static Future<Map<String, int>> loadProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final result = {
        'totalQuestions': prefs.getInt(_totalQuestionsKey) ?? 0,
        'correctAnswers': prefs.getInt(_correctAnswersKey) ?? 0,
        'wrongAnswers': prefs.getInt(_wrongAnswersKey) ?? 0,
        'targetQuestions': prefs.getInt(_targetQuestionsKey) ?? 100,
      };
      print('Общий прогресс загружен: $result');
      return result;
    } catch (e) {
      print('Ошибка при загрузке общего прогресса: $e');
      return {
        'totalQuestions': 0,
        'correctAnswers': 0,
        'wrongAnswers': 0,
        'targetQuestions': 100,
      };
    }
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
        
        // Также удаляем файловый резерв
        await _deleteFile(category.code);
      }
      
      print('Прогресс категории ${category.code} полностью сброшен');
    } catch (e) {
      print('Ошибка при сбросе прогресса категории ${category.code}: $e');
    }
  }

  // Удалить файл прогресса
  static Future<void> _deleteFile(String categoryCode) async {
    try {
      final filePath = await _getProgressFilePath(categoryCode);
      if (filePath.isNotEmpty) {
        final file = File(filePath);
        if (await file.exists()) {
          await file.delete();
          print('Файл прогресса удален: $filePath');
        }
      }
    } catch (e) {
      print('Ошибка при удалении файла прогресса: $e');
    }
  }

  // Получить прогресс для конкретной категории
  static Future<Map<String, int>> loadCategoryProgress(VerbCategory category) async {
    try {
      final categoryKey = '${category.code}_';
      
      // Рассчитываем целевое количество заданий динамически
      final calculatedTargetQuestions = AllVerbData.getTargetQuestionsForCategory(category);
      
      Map<String, int> result;
      
      // Принудительно используем SharedPreferences на мобильных устройствах
      if (_isMobile) {
        // Сначала пробуем SharedPreferences
        try {
          final prefs = await SharedPreferences.getInstance();
          result = {
            'totalQuestions': prefs.getInt('${categoryKey}total') ?? 0,
            'correctAnswers': prefs.getInt('${categoryKey}correct') ?? 0,
            'wrongAnswers': prefs.getInt('${categoryKey}wrong') ?? 0,
            'targetQuestions': calculatedTargetQuestions, // Используем рассчитанное значение
          };
          print('Прогресс категории ${category.code} загружен из SharedPreferences: $result');
          
          // Если все значения равны 0, пробуем загрузить из файла
          if (result['totalQuestions'] == 0 && result['correctAnswers'] == 0 && result['wrongAnswers'] == 0) {
            final fileResult = await _loadFromFile(category.code);
            if (fileResult['totalQuestions']! > 0 || fileResult['correctAnswers']! > 0 || fileResult['wrongAnswers']! > 0) {
              result = fileResult;
              // Обновляем целевое количество заданий на рассчитанное
              result['targetQuestions'] = calculatedTargetQuestions;
              print('Прогресс категории ${category.code} восстановлен из файла: $result');
            }
          }
        } catch (e) {
          print('Ошибка при загрузке из SharedPreferences, пробуем файл: $e');
          result = await _loadFromFile(category.code);
          // Обновляем целевое количество заданий на рассчитанное
          result['targetQuestions'] = calculatedTargetQuestions;
        }
      } else {
        // Используем localStorage для веб-версии
        result = {
          'totalQuestions': _loadFromLocalStorage('${categoryKey}total', 0),
          'correctAnswers': _loadFromLocalStorage('${categoryKey}correct', 0),
          'wrongAnswers': _loadFromLocalStorage('${categoryKey}wrong', 0),
          'targetQuestions': calculatedTargetQuestions, // Используем рассчитанное значение
        };
        print('Прогресс категории ${category.code} загружен из localStorage: $result');
      }
      
      return result;
    } catch (e) {
      print('Ошибка при загрузке прогресса категории ${category.code}: $e');
      return {
        'totalQuestions': 0,
        'correctAnswers': 0,
        'wrongAnswers': 0,
        'targetQuestions': AllVerbData.getTargetQuestionsForCategory(category), // Используем рассчитанное значение даже при ошибке
      };
    }
  }

  // Сохранить прогресс для конкретной категории
  static Future<void> saveCategoryProgress({
    required VerbCategory category,
    required int totalQuestions,
    required int correctAnswers,
    required int wrongAnswers,
    int? targetQuestions, // Сделаем опциональным, чтобы использовать динамический расчет
  }) async {
    try {
      final categoryKey = '${category.code}_';
      
      // Используем переданное значение или рассчитываем динамически
      final finalTargetQuestions = targetQuestions ?? AllVerbData.getTargetQuestionsForCategory(category);
      
      final progress = {
        'totalQuestions': totalQuestions,
        'correctAnswers': correctAnswers,
        'wrongAnswers': wrongAnswers,
        'targetQuestions': finalTargetQuestions,
      };
      
      // Принудительно используем SharedPreferences на мобильных устройствах
      if (_isMobile) {
        // Используем SharedPreferences для мобильных версий
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('${categoryKey}total', totalQuestions);
        await prefs.setInt('${categoryKey}correct', correctAnswers);
        await prefs.setInt('${categoryKey}wrong', wrongAnswers);
        await prefs.setInt('${categoryKey}target', finalTargetQuestions);
        print('Прогресс категории ${category.code} сохранен в SharedPreferences: total=$totalQuestions, correct=$correctAnswers, wrong=$wrongAnswers, target=$finalTargetQuestions');
        
        // Дополнительно сохраняем в файл как резерв
        await _saveToFile(category.code, progress);
      } else {
        // Используем localStorage для веб-версии
        _saveToLocalStorage('${categoryKey}total', totalQuestions);
        _saveToLocalStorage('${categoryKey}correct', correctAnswers);
        _saveToLocalStorage('${categoryKey}wrong', wrongAnswers);
        _saveToLocalStorage('${categoryKey}target', finalTargetQuestions);
        print('Прогресс категории ${category.code} сохранен в localStorage: total=$totalQuestions, correct=$correctAnswers, wrong=$wrongAnswers, target=$finalTargetQuestions');
      }
    } catch (e) {
      print('Ошибка при сохранении прогресса категории ${category.code}: $e');
    }
  }

  // Получить текущую дату в формате YYYY-MM-DD
  static String _getCurrentDateString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  // Получить дату последнего сброса Daily квиза
  static Future<String> _getLastDailyResetDate() async {
    try {
      if (_isWeb) {
        return html.window.localStorage['daily_last_reset'] ?? '';
      } else {
        final prefs = await SharedPreferences.getInstance();
        return prefs.getString('daily_last_reset') ?? '';
      }
    } catch (e) {
      print('Ошибка при получении даты последнего сброса Daily: $e');
      return '';
    }
  }

  // Сохранить дату последнего сброса Daily квиза
  static Future<void> _setLastDailyResetDate(String date) async {
    try {
      if (_isWeb) {
        html.window.localStorage['daily_last_reset'] = date;
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('daily_last_reset', date);
      }
      print('Дата последнего сброса Daily установлена: $date');
    } catch (e) {
      print('Ошибка при сохранении даты последнего сброса Daily: $e');
    }
  }

  // Проверить, нужно ли сбросить Daily квиз (новая дата)
  static Future<bool> _shouldResetDailyQuiz() async {
    try {
      final currentDate = _getCurrentDateString();
      final lastResetDate = await _getLastDailyResetDate();
      
      print('Проверка сброса Daily квиза:');
      print('  Текущая дата: $currentDate');
      print('  Последний сброс: $lastResetDate');
      
      // Если даты разные, значит наступил новый день
      final shouldReset = currentDate != lastResetDate;
      print('  Нужен сброс: $shouldReset');
      
      return shouldReset;
    } catch (e) {
      print('Ошибка при проверке необходимости сброса Daily квиза: $e');
      return false;
    }
  }

  // Автоматический сброс Daily квиза при необходимости
  static Future<void> checkAndResetDailyQuiz() async {
    try {
      final shouldReset = await _shouldResetDailyQuiz();
      
      if (shouldReset) {
        print('🔄 Выполняется автоматический сброс Daily квиза...');
        
        // Сбрасываем прогресс Daily квиза
        await resetCategoryProgress(VerbCategory.daily);
        
        // Обновляем дату последнего сброса
        final currentDate = _getCurrentDateString();
        await _setLastDailyResetDate(currentDate);
        
        print('✅ Daily квиз успешно сброшен для даты: $currentDate');
      } else {
        print('ℹ️ Daily квиз не требует сброса');
      }
    } catch (e) {
      print('Ошибка при автоматическом сбросе Daily квиза: $e');
    }
  }

  // Принудительный сброс Daily квиза (для тестирования)
  static Future<void> forceResetDailyQuiz() async {
    try {
      print('🔄 Выполняется принудительный сброс Daily квиза...');
      
      // Сбрасываем прогресс Daily квиза
      await resetCategoryProgress(VerbCategory.daily);
      
      // Обновляем дату последнего сброса на текущую
      final currentDate = _getCurrentDateString();
      await _setLastDailyResetDate(currentDate);
      
      print('✅ Daily квиз принудительно сброшен для даты: $currentDate');
    } catch (e) {
      print('Ошибка при принудительном сбросе Daily квиза: $e');
    }
  }
}