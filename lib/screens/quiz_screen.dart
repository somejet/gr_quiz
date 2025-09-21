import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/verb_category.dart';
import '../models/quiz_question.dart';
import '../models/greek_verb.dart';
import '../models/person.dart';
import '../utils/quiz_generator.dart';
import '../utils/greek_text_utils.dart';
import '../utils/progress_storage.dart';
import '../widgets/greek_keyboard.dart';
import '../data/all_verb_data.dart';
import 'verbs_list_screen.dart';
import 'conjugation_rules_screen.dart';

class QuizScreen extends StatefulWidget {
  final VerbCategory category;

  const QuizScreen({super.key, required this.category});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with TickerProviderStateMixin {
  QuizQuestion? _currentQuestion;
  final TextEditingController _answerController = TextEditingController();
  int _correctAnswers = 0;
  int _wrongAnswers = 0;
  int _totalQuestions = 0;
  int _totalQuestionsAsked = 0;
  int _targetQuestions = 100;
  bool _showResult = false;
  bool _isCorrect = false;
  bool _isStressWarning = false;
  String _userAnswer = '';
  String? _warningMessage;
  bool _isTooltipVisible = false;
  bool _isQuizCompleted = false; // Добавляем флаг завершения квиза
  bool _isButtonPressed = false; // Состояние нажатия кнопки
  late FocusNode _answerFocusNode;
  
  late AnimationController _questionAnimationController;
  late AnimationController _resultAnimationController;
  late AnimationController _progressAnimationController;
  late AnimationController _glowController;
  late Animation<double> _questionFadeAnimation;
  late Animation<double> _questionScaleAnimation;
  late Animation<double> _resultSlideAnimation;
  late Animation<double> _progressAnimation;
  late Animation<double> _glowAnimation;
  late FocusNode _keyboardFocusNode;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeApp();
    _keyboardFocusNode = FocusNode();
    _answerFocusNode = FocusNode();
  }

  void _initializeAnimations() {
    _questionAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _resultAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _questionFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _questionAnimationController,
      curve: Curves.easeOutCubic,
    ));
    
    _questionScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _questionAnimationController,
      curve: Curves.easeOutBack,
    ));
    
    _resultSlideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _resultAnimationController,
      curve: Curves.easeOutCubic,
    ));
    
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeOutCubic,
    ));
    
    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _questionAnimationController.dispose();
    _resultAnimationController.dispose();
    _progressAnimationController.dispose();
    _glowController.dispose();
    _answerController.dispose();
    _keyboardFocusNode.dispose();
    _answerFocusNode.dispose();
    _tooltipTimer?.cancel(); // Отменяем таймер тултипа
    _hideTooltip(); // Очищаем overlay при dispose
    // Сохраняем прогресс при выходе из экрана
    _saveProgress();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    await _loadProgress();
    _generateNewQuestion();
    _progressAnimationController.forward();
    _glowController.repeat(reverse: true);
  }

  Future<void> _loadProgress() async {
    // Если это Daily квиз, проверяем необходимость сброса
    if (widget.category == VerbCategory.daily) {
      await ProgressStorage.checkAndResetDailyQuiz();
    }
    
    final progress = await ProgressStorage.loadCategoryProgress(widget.category);
    setState(() {
      _totalQuestionsAsked = progress['totalQuestions'] ?? 0;
      _correctAnswers = progress['correctAnswers'] ?? 0;
      _wrongAnswers = progress['wrongAnswers'] ?? 0;
      _targetQuestions = progress['targetQuestions'] ?? 100;
    });
  }

  Future<void> _saveProgress() async {
    try {
      await ProgressStorage.saveCategoryProgress(
        category: widget.category,
        totalQuestions: _totalQuestionsAsked,
        correctAnswers: _correctAnswers,
        wrongAnswers: _wrongAnswers,
        targetQuestions: _targetQuestions,
      );
      print('Прогресс сохранен: total=$_totalQuestionsAsked, correct=$_correctAnswers, wrong=$_wrongAnswers');
    } catch (e) {
      print('Ошибка при сохранении прогресса: $e');
    }
  }

  void _showVerbsList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerbsListScreen(category: widget.category),
      ),
    );
  }

  void _showConjugationRules() {
    // Находим глагол по вопросу
    GreekVerb? currentVerb;
    if (_currentQuestion != null) {
      final allVerbs = AllVerbData.getAllVerbs();
      currentVerb = allVerbs.firstWhere(
        (verb) => verb.conjugations.any(
          (conjugation) => conjugation.greekForm == _currentQuestion!.question ||
                         conjugation.russianTranslation == _currentQuestion!.question,
        ),
        orElse: () => allVerbs.firstWhere(
          (verb) => verb.category == widget.category,
        ),
      );
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConjugationRulesScreen(
          category: widget.category,
          currentVerb: currentVerb,
        ),
      ),
    );
  }

  void _generateNewQuestion() {
    setState(() {
      _currentQuestion = QuizGenerator.generateRandomQuestion(widget.category);
      _answerController.clear();
      _showResult = false;
      _isCorrect = false;
      _isStressWarning = false;
      _userAnswer = '';
      _warningMessage = null;
    });
    
    _questionAnimationController.reset();
    _questionAnimationController.forward();
    _resultAnimationController.reset();
  }

  void _checkAnswer() {
    if (_answerController.text.trim().isEmpty || _currentQuestion == null) return;

    setState(() {
      _userAnswer = _answerController.text.trim();
      final validationResult = _currentQuestion!.validateAnswer(_userAnswer);
      _isCorrect = validationResult.isCorrect;
      _isStressWarning = validationResult.isStressWarning;
      _warningMessage = validationResult.message;
      _showResult = true;
      _totalQuestions++;
      _totalQuestionsAsked++;

      if (_isCorrect) {
        _correctAnswers++;
      } else {
        _wrongAnswers++;
      }
      
      _saveProgress();
    });
    
    _resultAnimationController.forward();
  }

  void _nextQuestion() {
    // Проверяем завершение квиза перед генерацией нового вопроса
    _checkQuizCompletion();
    
    if (!_isQuizCompleted) {
      _generateNewQuestion();
      // Сохраняем прогресс при переходе к следующему вопросу
      _saveProgress();
    }
  }

  void _checkQuizCompletion() {
    final progress = _totalQuestionsAsked / _targetQuestions;
    if (progress >= 1.0 && !_isQuizCompleted) {
      setState(() {
        _isQuizCompleted = true;
      });
      
      // Показываем диалог завершения квиза
      _showQuizCompletionDialog();
    }
  }

  void _showQuizCompletionDialog() {
    final correctPercentage = _totalQuestionsAsked > 0 
        ? (_correctAnswers / _totalQuestionsAsked * 100).round()
        : 0;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A2E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.celebration,
                color: _getCategoryColor(),
                size: 32,
              ),
              const SizedBox(width: 12),
              const Text(
                'Поздравляем!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Вы завершили квиз по категории "${widget.category.description}"!',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF374151),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Всего заданий:',
                          style: TextStyle(color: Colors.white70),
                        ),
                        Text(
                          '$_totalQuestionsAsked',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Правильно:',
                          style: TextStyle(color: Colors.green),
                        ),
                        Text(
                          '$_correctAnswers',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Неправильно:',
                          style: TextStyle(color: Colors.red),
                        ),
                        Text(
                          '$_wrongAnswers',
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Точность:',
                          style: TextStyle(color: Colors.white70),
                        ),
                        Text(
                          '$correctPercentage%',
                          style: TextStyle(
                            color: _getCategoryColor(),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Возвращаемся на главный экран
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _getCategoryColors(),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Завершить',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onKeyPressed(String key) {
    if (key == 'Backspace') {
      if (_answerController.text.isNotEmpty) {
        _answerController.text = _answerController.text.substring(0, _answerController.text.length - 1);
        _answerController.selection = TextSelection.fromPosition(
          TextPosition(offset: _answerController.text.length),
        );
      }
    } else if (key == '΄') {
      _addStressToLastVowel();
    } else {
      final currentPosition = _answerController.selection.baseOffset;
      final newText = _answerController.text.substring(0, currentPosition) +
          key +
          _answerController.text.substring(currentPosition);
      _answerController.text = newText;
      _answerController.selection = TextSelection.fromPosition(
        TextPosition(offset: currentPosition + key.length),
      );
    }
  }

  void _addStressToLastVowel() {
    final text = _answerController.text;
    final vowels = ['α', 'ε', 'η', 'ι', 'ο', 'υ', 'ω'];
    final stressedVowels = ['ά', 'έ', 'ή', 'ί', 'ό', 'ύ', 'ώ'];
    
    for (int i = text.length - 1; i >= 0; i--) {
      final char = text[i];
      if (vowels.contains(char)) {
        final stressedChar = stressedVowels[vowels.indexOf(char)];
        final newText = text.substring(0, i) + stressedChar + text.substring(i + 1);
        _answerController.text = newText;
        _answerController.selection = TextSelection.fromPosition(
          TextPosition(offset: i + 1),
        );
        break;
      }
    }
  }

  OverlayEntry? _tooltipOverlay;
  final GlobalKey _questionTextKey = GlobalKey();
  Timer? _tooltipTimer;

  void _showTooltip(BuildContext context) {
    if (_isTooltipVisible) {
      // Если тултип уже показан, просто скрываем его
      _hideTooltip();
      return;
    }
    
    setState(() {
      _isTooltipVisible = true;
    });
    
    // Получаем точную позицию текста вопроса через GlobalKey
    final RenderBox? textRenderBox = _questionTextKey.currentContext?.findRenderObject() as RenderBox?;
    if (textRenderBox == null) return;
    
    final Offset textPosition = textRenderBox.localToGlobal(Offset.zero);
    final Size textSize = textRenderBox.size;
    
    // Получаем размер экрана для правильного позиционирования
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;
    
    // Вычисляем текст тултипа
    final String tooltipText = _isStressWarning 
        ? 'Правильно, но обратите внимание на ударение. Правильно: ${_getFormattedCorrectAnswer()}'
        : _getTooltipMessage();
    
    // Вычисляем размер текста для правильного центрирования
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: tooltipText,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: null,
    );
    textPainter.layout(maxWidth: 200);
    
    // Центрируем тултип точно над текстом вопроса
    final double tooltipWidth = textPainter.width.clamp(120.0, 200.0);
    final double tooltipLeft = (textPosition.dx + textSize.width / 2) - (tooltipWidth / 2);
    
    // Проверяем, чтобы тултип не выходил за границы экрана
    final double clampedLeft = tooltipLeft.clamp(8.0, screenWidth - tooltipWidth - 8.0);
    
    _tooltipOverlay = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () {
          _hideTooltip();
        },
        child: Stack(
          children: [
            // Прозрачный фон для закрытия тултипа
            Positioned.fill(
              child: Container(
                color: Colors.transparent,
              ),
            ),
            // Сам тултип
            Positioned(
              left: clampedLeft,
              top: textPosition.dy - 80, // Показываем выше, чтобы не перекрывать слово
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: tooltipWidth,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: _getCategoryColor().withOpacity(0.95),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    tooltipText,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    
    Overlay.of(context).insert(_tooltipOverlay!);
    
    // Отменяем предыдущий таймер если он есть
    _tooltipTimer?.cancel();
    
    // Автоматически скрываем тултип через 3 секунды
    _tooltipTimer = Timer(const Duration(seconds: 3), () {
      if (_isTooltipVisible) {
        _hideTooltip();
      }
    });
  }

  void _hideTooltip() {
    // Отменяем таймер
    _tooltipTimer?.cancel();
    _tooltipTimer = null;
    
    if (_tooltipOverlay != null) {
      _tooltipOverlay!.remove();
      _tooltipOverlay = null;
    }
    setState(() {
      _isTooltipVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Настройка статус-бара для белого текста
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // Белые иконки
        statusBarBrightness: Brightness.dark, // Темный фон для iOS
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    // Добавляем обработку клавиши Enter только для десктопных устройств
    final isDesktop = MediaQuery.of(context).size.width > 600;
    
    Widget content;
    if (isDesktop) {
      content = KeyboardListener(
        focusNode: _keyboardFocusNode,
        onKeyEvent: (KeyEvent event) {
          if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
            if (_showResult) {
              _nextQuestion();
            } else if (_answerController.text.trim().isNotEmpty) {
              _checkAnswer();
            }
          }
        },
        child: _buildMainContent(),
      );
    } else {
      content = _buildMainContent();
    }
    
    // Обертываем в WillPopScope для предотвращения потери фокуса
    return WillPopScope(
      onWillPop: () async {
        // Предотвращаем потерю фокуса при системных событиях
        if (_answerFocusNode.hasFocus) {
          return false;
        }
        return true;
      },
      child: content,
    );
  }

  Widget _buildMainContent() {
    // Убеждаемся, что фокус установлен для обработки клавиш только на десктопе
    final isDesktop = MediaQuery.of(context).size.width > 600;
    if (isDesktop) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _keyboardFocusNode.requestFocus();
      });
    }
    
    if (_currentQuestion == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0F0F23),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: _getCategoryColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getCategoryColor().withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: CircularProgressIndicator(
                  color: _getCategoryColor(),
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Загружаем вопросы...',
                style: TextStyle(
                  fontSize: 16,
                  color: const Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23),
      body: SafeArea(
        child: Column(
          children: [
            // Современный темный AppBar с градиентом
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF1A1A2E),
                    _getCategoryColor().withOpacity(0.2),
                    const Color(0xFF16213E),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: _getCategoryColor().withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Глаголы ${widget.category.code}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.list,
                          color: Colors.white,
                          size: 24,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.8),
                              blurRadius: 4,
                              offset: const Offset(1, 1),
                            ),
                          ],
                        ),
                        onPressed: _showVerbsList,
                        tooltip: 'Список глаголов',
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.info_outline,
                          color: Colors.white,
                          size: 24,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.8),
                              blurRadius: 4,
                              offset: const Offset(1, 1),
                            ),
                          ],
                        ),
                        onPressed: _showConjugationRules,
                        tooltip: 'Правила спряжения',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Контент
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Прогресс
                    _buildProgressSection(),
                    const SizedBox(height: 16),
                    
                    // Вопрос
                    Expanded(
                      flex: 2,
                      child: _buildQuestionCard(),
                    ),
                    const SizedBox(height: 16),
                    
                    // Поле ввода и результат
                    Expanded(
                      flex: 2,
                      child: _buildAnswerSection(),
                    ),
                    const SizedBox(height: 16),
                    
                    // Кнопка действия
                    _buildActionButton(),
                    const SizedBox(height: 16),
                    
                    // Клавиатура (только для десктопа)
                    if (MediaQuery.of(context).size.width > 600)
                      Expanded(
                        flex: 3,
                        child: GreekKeyboard(
                          onKeyPressed: _onKeyPressed,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
    
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width > 600 ? 20 : 16,
            vertical: MediaQuery.of(context).size.width > 600 ? 16 : 12,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _getCategoryColor().withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Компактная полоска прогресса с цветовой индикацией
              Container(
                height: MediaQuery.of(context).size.width > 600 ? 24 : 20,
                decoration: BoxDecoration(
                  color: const Color(0xFF374151),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    // Фоновая полоска
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF374151),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    // Единая полоска прогресса (зеленые + красные сегменты)
                    Row(
                      children: [
                        // Правильные ответы (зеленые)
                        if (_correctAnswers > 0)
                          Expanded(
                            flex: _correctAnswers,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(12),
                                  bottomLeft: const Radius.circular(12),
                                  topRight: _wrongAnswers > 0 ? Radius.zero : const Radius.circular(12),
                                  bottomRight: _wrongAnswers > 0 ? Radius.zero : const Radius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        // Неправильные ответы (красные)
                        if (_wrongAnswers > 0)
                          Expanded(
                            flex: _wrongAnswers,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.only(
                                  topLeft: _correctAnswers > 0 ? Radius.zero : const Radius.circular(12),
                                  bottomLeft: _correctAnswers > 0 ? Radius.zero : const Radius.circular(12),
                                  topRight: const Radius.circular(12),
                                  bottomRight: const Radius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        // Пустое место для неотвеченных вопросов
                        if (_totalQuestionsAsked < _targetQuestions)
                          Expanded(
                            flex: _targetQuestions - _totalQuestionsAsked,
                            child: Container(),
                          ),
                      ],
                    ),
                    // Текст прогресса поверх полоски
                    Center(
                      child: Text(
                        _isQuizCompleted ? '$_targetQuestions/$_targetQuestions ✓' : '$_totalQuestionsAsked/$_targetQuestions',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width > 600 ? 14 : 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.8),
                              blurRadius: 2,
                              offset: const Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildQuestionCard() {
    return AnimatedBuilder(
      animation: _questionAnimationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _questionFadeAnimation,
          child: ScaleTransition(
            scale: _questionScaleAnimation,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(MediaQuery.of(context).size.width > 600 ? 16 : 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: _getCategoryColor().withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Сохраняем фокус перед показом тултипа
                      final bool wasFocused = _answerFocusNode.hasFocus;
                      _showTooltip(context);
                      // Восстанавливаем фокус если он был
                      if (wasFocused) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _answerFocusNode.requestFocus();
                        });
                      }
                    },
                    // Предотвращаем потерю фокуса при клике на слово
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedBuilder(
                      animation: _glowAnimation,
                      builder: (context, child) {
                        return Text(
                          key: _questionTextKey,
                          _currentQuestion!.question,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width > 600 ? 28 : 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                            decorationStyle: TextDecorationStyle.dotted,
                            decorationColor: _getCategoryColor().withOpacity(0.6),
                            decorationThickness: 2,
                            shadows: [
                              Shadow(
                                color: _getCategoryColor().withOpacity(0.3 * _glowAnimation.value),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnswerSection() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Поле ввода
          Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width > 600 ? 16 : 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: TextField(
              controller: _answerController,
              focusNode: _answerFocusNode,
              enabled: !_showResult,
              keyboardType: TextInputType.text,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: 'Переведите',
                labelStyle: const TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w500,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: const Color(0xFF374151)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: const Color(0xFF374151)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: _getCategoryColor(), width: 2),
                ),
                filled: true,
                fillColor: _showResult 
                    ? (_isCorrect ? Colors.green[900]!.withOpacity(0.3) : 
                       _isStressWarning ? Colors.orange[900]!.withOpacity(0.3) : Colors.red[900]!.withOpacity(0.3))
                    : const Color(0xFF374151),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _checkAnswer(),
            ),
          ),
          
          // Результат
          if (_showResult) ...[
            const SizedBox(height: 12),
            AnimatedBuilder(
              animation: _resultAnimationController,
              builder: (context, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(_resultAnimationController),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _isCorrect 
                          ? Colors.green[900]!.withOpacity(0.3) 
                          : _isStressWarning 
                              ? Colors.orange[900]!.withOpacity(0.3) 
                              : Colors.red[900]!.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _isCorrect 
                            ? Colors.green[400]! 
                            : _isStressWarning 
                                ? Colors.orange[400]! 
                                : Colors.red[400]!,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _isCorrect ? Icons.check_circle : 
                          _isStressWarning ? Icons.warning : Icons.cancel,
                          color: _isCorrect ? Colors.green[400] : 
                                 _isStressWarning ? Colors.orange[400] : Colors.red[400],
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _isCorrect 
                                ? 'Правильно!' 
                                : _isStressWarning 
                                    ? 'Правильно, но обратите внимание на ударение. Правильно: ${_getFormattedCorrectAnswer()}'
                                    : 'Правильный ответ: ${_getFormattedCorrectAnswer()}',
                            style: TextStyle(
                              color: _isCorrect ? Colors.green[300] : 
                                     _isStressWarning ? Colors.orange[300] : Colors.red[300],
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.width > 600 ? 48 : 44,
      child: GestureDetector(
        onTapDown: (_) {
          setState(() {
            _isButtonPressed = true;
          });
        },
        onTapUp: (_) {
          setState(() {
            _isButtonPressed = false;
          });
          _showResult ? _nextQuestion() : _checkAnswer();
        },
        onTapCancel: () {
          setState(() {
            _isButtonPressed = false;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          transform: _isButtonPressed 
              ? (Matrix4.identity()..scale(0.98))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _showResult && !_isStressWarning 
                  ? [const Color(0xFF3B82F6), const Color(0xFF1E40AF)]
                  : _isStressWarning 
                      ? [const Color(0xFFF59E0B), const Color(0xFFD97706)]
                      : _getCategoryColors(),
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: (_showResult && !_isStressWarning 
                    ? const Color(0xFF3B82F6)
                    : _isStressWarning 
                        ? const Color(0xFFF59E0B)
                        : _getCategoryColor()).withOpacity(_isButtonPressed ? 0.2 : 0.3),
                blurRadius: _isButtonPressed ? 8 : 12,
                offset: Offset(0, _isButtonPressed ? 2 : 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              _showResult && !_isStressWarning ? 'Следующий вопрос' : 
              _isStressWarning ? 'Понятно, следующий вопрос' : 'Проверить',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getTooltipMessage() {
    if (_currentQuestion!.type == QuestionType.greekToRussian) {
      return 'Перевод: ${_getInfinitiveTranslation()}';
    } else {
      return 'Греческий инфинитив: ${_getGreekInfinitive()}';
    }
  }

  String _getInfinitiveTranslation() {
    final verb = _getCurrentVerb();
    return verb?.russianTranslation ?? 'неизвестно';
  }

  String _getGreekInfinitive() {
    final verb = _getCurrentVerb();
    return verb?.infinitive ?? 'неизвестно';
  }

  String _getFormattedCorrectAnswer() {
    if (_currentQuestion!.type == QuestionType.greekToRussian) {
      // Для русских ответов показываем только основной правильный ответ
      return _currentQuestion!.correctAnswer;
    } else {
      // Для греческих ответов проверяем, нужно ли показывать две формы
      if (_currentQuestion!.person == Person.secondPlural && 
          (_currentQuestion!.category == VerbCategory.gamma1 || 
           _currentQuestion!.category == VerbCategory.gamma2)) {
        // Для Г1/Г2 "вы" показываем полную и сокращенную формы
        List<String> uniqueAnswers = _currentQuestion!.allPossibleAnswers.toSet().toList();
        
        if (uniqueAnswers.length == 1) {
          return uniqueAnswers.first;
        } else {
          // Сортируем: сначала полная форма, потом короткие
          uniqueAnswers.sort((a, b) {
            if (a.length > b.length) return -1;
            if (a.length < b.length) return 1;
            return 0;
          });
          
          // Показываем максимум 2 варианта для читаемости
          List<String> displayAnswers = uniqueAnswers.take(2).toList();
          return displayAnswers.join(' / ');
        }
      } else {
        // Для всех остальных форм показываем только один правильный ответ
        return _currentQuestion!.correctAnswer;
      }
    }
  }

  GreekVerb? _getCurrentVerb() {
    // Для Daily квиза ищем глагол во всех категориях
    final verbs = widget.category == VerbCategory.daily 
        ? AllVerbData.getAllVerbs()
        : AllVerbData.getVerbsByCategory(_currentQuestion!.category);
    
    for (final verb in verbs) {
      for (final conjugation in verb.conjugations) {
        if (_currentQuestion!.type == QuestionType.greekToRussian) {
          final questionText = _currentQuestion!.question.split(' ')[0];
          if (conjugation.greekForm == questionText) {
            return verb;
          }
        } else {
          final questionText = _currentQuestion!.question.split(' ')[0];
          if (conjugation.russianTranslation == questionText) {
            return verb;
          }
        }
      }
    }
    return null;
  }

  Color _getCategoryColor() {
    switch (widget.category) {
      case VerbCategory.daily:
        return const Color(0xFFFF6B6B);
      case VerbCategory.a:
        return const Color(0xFF3B82F6);
      case VerbCategory.b1:
        return const Color(0xFF10B981);
      case VerbCategory.b2:
        return const Color(0xFFF59E0B);
      case VerbCategory.ab:
        return const Color(0xFF8B5CF6);
      case VerbCategory.gamma1:
        return const Color(0xFFEF4444);
      case VerbCategory.gamma2:
        return const Color(0xFF06B6D4);
    }
  }

  List<Color> _getCategoryColors() {
    switch (widget.category) {
      case VerbCategory.daily:
        return [const Color(0xFFFF6B6B), const Color(0xFFEE5A52)];
      case VerbCategory.a:
        return [const Color(0xFF3B82F6), const Color(0xFF1E40AF)];
      case VerbCategory.b1:
        return [const Color(0xFF10B981), const Color(0xFF047857)];
      case VerbCategory.b2:
        return [const Color(0xFFF59E0B), const Color(0xFFD97706)];
      case VerbCategory.ab:
        return [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)];
      case VerbCategory.gamma1:
        return [const Color(0xFFEF4444), const Color(0xFFDC2626)];
      case VerbCategory.gamma2:
        return [const Color(0xFF06B6D4), const Color(0xFF0891B2)];
    }
  }
}