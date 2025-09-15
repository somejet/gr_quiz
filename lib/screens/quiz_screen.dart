import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/verb_category.dart';
import '../models/quiz_question.dart';
import '../models/greek_verb.dart';
import '../utils/quiz_generator.dart';
import '../utils/greek_text_utils.dart';
import '../utils/progress_storage.dart';
import '../widgets/greek_keyboard.dart';
import '../data/all_verb_data.dart';

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
  late FocusNode _textFieldFocusNode;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeApp();
    _keyboardFocusNode = FocusNode();
    _textFieldFocusNode = FocusNode();
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
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    await _loadProgress();
    _generateNewQuestion();
    _progressAnimationController.forward();
    _glowController.repeat(reverse: true);
  }

  Future<void> _loadProgress() async {
    final progress = await ProgressStorage.loadCategoryProgress(widget.category);
    setState(() {
      _totalQuestionsAsked = progress['totalQuestions'] ?? 0;
      _correctAnswers = progress['correctAnswers'] ?? 0;
      _wrongAnswers = progress['wrongAnswers'] ?? 0;
      _targetQuestions = progress['targetQuestions'] ?? 100;
    });
  }

  Future<void> _saveProgress() async {
    await ProgressStorage.saveCategoryProgress(
      category: widget.category,
      totalQuestions: _totalQuestionsAsked,
      correctAnswers: _correctAnswers,
      wrongAnswers: _wrongAnswers,
      targetQuestions: _targetQuestions,
    );
  }

  Future<void> _resetProgress() async {
    await ProgressStorage.resetProgress();
    setState(() {
      _totalQuestionsAsked = 0;
      _correctAnswers = 0;
      _wrongAnswers = 0;
      _totalQuestions = 0;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Прогресс сброшен'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: const Color(0xFF1A1A2E),
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
    _generateNewQuestion();
    // На мобильных устройствах автоматически фокусируемся на поле ввода
    if (MediaQuery.of(context).size.width <= 600) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _textFieldFocusNode.requestFocus();
      });
    }
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

  @override
  Widget build(BuildContext context) {
    // Автоматический фокус на мобильных устройствах
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenWidth = MediaQuery.of(context).size.width;
      print('Screen width: $screenWidth, Show result: $_showResult');
      if (screenWidth <= 600 && !_showResult) {
        print('Requesting focus for mobile device');
        _textFieldFocusNode.requestFocus();
      }
    });
    
    // Добавляем обработку клавиши Enter для перехода к следующему вопросу
    return KeyboardListener(
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
  }

  Widget _buildMainContent() {
    // Убеждаемся, что фокус установлен для обработки клавиш
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _keyboardFocusNode.requestFocus();
    });
    
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
                          'Квиз - ${widget.category.code}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Изучайте греческие глаголы',
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xFF9CA3AF),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: _resetProgress,
                    tooltip: 'Сбросить прогресс',
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
                    
                    // Клавиатура (только на десктопе)
                    if (MediaQuery.of(context).size.width > 600) ...[
                      Expanded(
                        flex: 3,
                        child: GreekKeyboard(
                          onKeyPressed: _onKeyPressed,
                        ),
                      ),
                    ],
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
    final progress = _totalQuestionsAsked / _targetQuestions;
    
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width > 600 ? 20 : 12),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildProgressStat('Прогресс', '$_totalQuestionsAsked/$_targetQuestions', _getCategoryColor()),
                  _buildProgressStat('✓ Правильно', '$_correctAnswers', Colors.green),
                  _buildProgressStat('✗ Неправильно', '$_wrongAnswers', Colors.red),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.width > 600 ? 16 : 8),
              Container(
                height: MediaQuery.of(context).size.width > 600 ? 8 : 6,
                decoration: BoxDecoration(
                  color: const Color(0xFF374151),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: (progress * _progressAnimation.value).clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _getCategoryColors(),
                      ),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: _getCategoryColor().withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: color,
            shadows: [
              Shadow(
                color: color.withOpacity(0.3),
                blurRadius: 5,
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF9CA3AF),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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
                  Tooltip(
                    message: _getTooltipMessage(),
                    preferBelow: false,
                    showDuration: const Duration(seconds: 4),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
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
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              _isStressWarning 
                                  ? 'Правильно, но обратите внимание на ударение. Правильно: ${_getCorrectAnswerForStressWarning()}'
                                  : _getTooltipMessage(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            duration: const Duration(seconds: 3),
                            backgroundColor: _getCategoryColor(),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                      child: AnimatedBuilder(
                        animation: _glowAnimation,
                        builder: (context, child) {
                          return Text(
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
            child: GestureDetector(
              onTap: () {
                if (!_showResult) {
                  _textFieldFocusNode.requestFocus();
                }
              },
              child: TextField(
                controller: _answerController,
                focusNode: _textFieldFocusNode,
                enabled: !_showResult,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                onSubmitted: (value) {
                  if (!_showResult && value.trim().isNotEmpty) {
                    _checkAnswer();
                  }
                },
              decoration: InputDecoration(
                labelText: 'Ваш ответ',
                labelStyle: const TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w500,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: const Color(0xFF374151)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: const Color(0xFF374151)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
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
              ),
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
                                    ? 'Правильно, но обратите внимание на ударение. Правильно: ${_getCorrectAnswerForStressWarning()}'
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
      child: ElevatedButton(
        onPressed: _showResult ? _nextQuestion : _checkAnswer,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ).copyWith(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
        ),
        child: Container(
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
                        : _getCategoryColor()).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
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
      // Для греческих ответов показываем полную и сокращенную формы
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
        
        // Показываем максимум 2 варианта: полную и сокращенную формы
        List<String> displayAnswers = uniqueAnswers.take(2).toList();
        return displayAnswers.join(' / ');
      }
    }
  }

  String _getCorrectAnswerForStressWarning() {
    // Для предупреждения об ударении показываем только основной правильный ответ
    return _currentQuestion!.correctAnswer;
  }

  GreekVerb? _getCurrentVerb() {
    final verbs = AllVerbData.getVerbsByCategory(_currentQuestion!.category);
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