import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/verb_category.dart';
import '../utils/progress_storage.dart';
import 'quiz_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

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

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23), // Темный фон как в примере
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Современный темный AppBar с градиентом
            SliverAppBar(
              expandedHeight: 140,
              floating: false,
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1A1A2E),
                        Color(0xFF16213E),
                        Color(0xFF0F0F23),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Греческий Квиз',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -1,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Изучайте греческие глаголы',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF9CA3AF),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            // Daily квиз тайл сверху
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width > 600 ? 24 : 16,
                MediaQuery.of(context).size.width > 600 ? 24 : 16,
                MediaQuery.of(context).size.width > 600 ? 24 : 16,
                MediaQuery.of(context).size.width > 600 ? 16 : 12,
              ),
              sliver: SliverToBoxAdapter(
                child: _DailyCard(),
              ),
            ),
            
            // Контент с темным фоном
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width > 600 ? 24 : 16,
                0,
                MediaQuery.of(context).size.width > 600 ? 24 : 16,
                MediaQuery.of(context).size.width > 600 ? 24 : 16,
              ),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: MediaQuery.of(context).size.width > 600 ? 16 : 12,
                  mainAxisSpacing: MediaQuery.of(context).size.width > 600 ? 16 : 12,
                  childAspectRatio: MediaQuery.of(context).size.width > 600 ? 1.1 : 1.2,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    // Пропускаем Daily категорию, так как она отображается отдельно
                    final category = VerbCategory.values[index + 1];
                    return _CategoryCard(category: category, index: index);
                  },
                  childCount: VerbCategory.values.length - 1, // Исключаем Daily
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final VerbCategory category;
  final int index;

  const _CategoryCard({
    required this.category,
    required this.index,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard>
    with TickerProviderStateMixin {
  Map<String, int>? _progress;
  bool _isLoading = true;
  bool _isHovered = false;
  late AnimationController _animationController;
  late AnimationController _scaleController;
  late AnimationController _glowController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _loadProgress();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    ));
    
    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
    
    // Запускаем анимацию появления с задержкой
    Future.delayed(Duration(milliseconds: widget.index * 150), () {
      if (mounted) {
        _animationController.forward();
        _scaleController.forward();
        _glowController.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scaleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  Future<void> _loadProgress() async {
    try {
      final progress = await ProgressStorage.loadCategoryProgress(widget.category);
      setState(() {
        _progress = progress;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToQuiz() async {
    // Анимация нажатия
    _scaleController.reverse().then((_) {
      _scaleController.forward();
    });
    
    await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            QuizScreen(category: widget.category),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;
          
          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );
          
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
    
    // Перезагружаем прогресс после возвращения из квиза
    await _loadProgress();
  }

  Future<void> _resetProgress() async {
    await ProgressStorage.resetCategoryProgress(widget.category);
    await _loadProgress();
    
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
    
    // Начинаем квиз после сброса прогресса
    _navigateToQuiz();
  }

  @override
  Widget build(BuildContext context) {
    final hasProgress = _progress != null && 
        (_progress!['totalQuestions']! > 0 || 
         _progress!['correctAnswers']! > 0 || 
         _progress!['wrongAnswers']! > 0);
    
    // Проверяем, завершен ли квиз (100% прогресс)
    final isCompleted = hasProgress && _progress != null &&
        _progress!['totalQuestions']! >= _progress!['targetQuestions']!;

    return AnimatedBuilder(
      animation: Listenable.merge([_fadeAnimation, _scaleAnimation, _glowAnimation]),
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: MouseRegion(
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                transform: Matrix4.identity()
                  ..translate(0.0, _isHovered ? -8.0 : 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: _getCategoryColors(widget.category)[0].withOpacity(0.2 * _glowAnimation.value),
                        blurRadius: _isHovered ? 30 : 20,
                        offset: Offset(0, _isHovered ? 12 : 8),
                        spreadRadius: _isHovered ? 4 : 2,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF1A1A2E),
                            _getCategoryColors(widget.category)[0].withOpacity(0.1),
                            const Color(0xFF16213E),
                          ],
                        ),
                        border: Border.all(
                          color: _getCategoryColors(widget.category)[0].withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: isCompleted ? null : _navigateToQuiz, // Отключаем клики для завершенных тайлов
                          borderRadius: BorderRadius.circular(24),
                          child: Padding(
                            padding: EdgeInsets.all(MediaQuery.of(context).size.width > 600 ? 20 : 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Иконка категории с эффектом свечения
                                AnimatedBuilder(
                                  animation: _glowAnimation,
                                  builder: (context, child) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width > 600 ? 50 : 40,
                                      height: MediaQuery.of(context).size.width > 600 ? 50 : 40,
                                      decoration: BoxDecoration(
                                        color: _getCategoryColors(widget.category)[0].withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: _getCategoryColors(widget.category)[0].withOpacity(0.5 * _glowAnimation.value),
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: _getCategoryColors(widget.category)[0].withOpacity(0.3 * _glowAnimation.value),
                                            blurRadius: 10,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          widget.category.code,
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.width > 600 ? 20 : 16,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                            shadows: [
                                              Shadow(
                                                color: _getCategoryColors(widget.category)[0].withOpacity(0.5),
                                                blurRadius: 8,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                
                                SizedBox(height: MediaQuery.of(context).size.width > 600 ? 12 : 8),
                                
                                // Описание
                                Text(
                                  widget.category.description,
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width > 600 ? 12 : 10,
                                    color: const Color(0xFF9CA3AF),
                                    fontWeight: FontWeight.w500,
                                    height: 1.2,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                
                                SizedBox(height: MediaQuery.of(context).size.width > 600 ? 16 : 8),
                                
                                // Контент в зависимости от состояния
                                if (_isLoading)
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width > 600 ? 28 : 24,
                                    height: MediaQuery.of(context).size.width > 600 ? 28 : 24,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                else if (isCompleted)
                                  _buildRestartButton()
                                else if (hasProgress)
                                  _buildProgressSection()
                                else
                                  _buildPlayButton(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressSection() {
    final totalQuestions = _progress!['totalQuestions']!;
    final targetQuestions = _progress!['targetQuestions']!;
    final progress = totalQuestions / targetQuestions;
    
    // Адаптивные размеры в зависимости от ширины экрана
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;
    
    final progressBarHeight = isWideScreen ? 6.0 : 4.0;
    final fontSize = isWideScreen ? 14.0 : 10.0;
    final spacing = isWideScreen ? 8.0 : 2.0;
    final buttonPadding = isWideScreen ? 8.0 : 4.0;
    final iconSize = isWideScreen ? 16.0 : 12.0;

    return Column(
      children: [
        // Прогресс бар с эффектом свечения
        Container(
          width: double.infinity,
          height: progressBarHeight,
          decoration: BoxDecoration(
            color: const Color(0xFF374151),
            borderRadius: BorderRadius.circular(progressBarHeight / 2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _getCategoryColors(widget.category),
                ),
                borderRadius: BorderRadius.circular(progressBarHeight / 2),
                boxShadow: [
                  BoxShadow(
                    color: _getCategoryColors(widget.category)[0].withOpacity(0.5),
                    blurRadius: progressBarHeight,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        ),
        
        SizedBox(height: spacing),
        
        // Статистика (только прогресс)
        Text(
          '$totalQuestions/$targetQuestions',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        
        SizedBox(height: spacing),
        
        // Кнопки только с иконками
        Row(
          children: [
            Expanded(
              child: _buildIconOnlyButton(
                onPressed: _navigateToQuiz,
                icon: Icons.play_arrow,
                isPrimary: true,
                padding: buttonPadding,
                iconSize: iconSize,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: _buildIconOnlyButton(
                onPressed: _resetProgress,
                icon: Icons.refresh,
                isPrimary: false,
                padding: buttonPadding,
                iconSize: iconSize,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRestartButton() {
    return Column(
      children: [
        // Показываем прогресс с иконкой завершения
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${_progress!['totalQuestions']}/${_progress!['targetQuestions']}',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width > 600 ? 12 : 10,
                fontWeight: FontWeight.w700,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: MediaQuery.of(context).size.width > 600 ? 16 : 14,
            ),
          ],
        ),
        
        SizedBox(height: MediaQuery.of(context).size.width > 600 ? 8 : 6),
        
        // Тонкая кнопка рестарта на всю ширину
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.width > 600 ? 28 : 24,
          child: ElevatedButton(
            onPressed: _resetProgress,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: _getCategoryColors(widget.category)[0].withOpacity(0.5),
                  width: 1,
                ),
              ),
            ),
            child: Icon(
              Icons.refresh,
              size: MediaQuery.of(context).size.width > 600 ? 16 : 14,
              color: _getCategoryColors(widget.category)[0],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayButton() {
    return _buildModernButton(
      onPressed: _navigateToQuiz,
      label: 'Начать',
      icon: Icons.play_arrow,
      isPrimary: true,
      isLarge: true,
    );
  }

  Widget _buildIconOnlyButton({
    required VoidCallback onPressed,
    required IconData icon,
    required bool isPrimary,
    required double padding,
    required double iconSize,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: padding,
              vertical: padding,
            ),
            decoration: BoxDecoration(
              gradient: isPrimary 
                  ? LinearGradient(
                      colors: _getCategoryColors(widget.category),
                    )
                  : null,
              color: isPrimary 
                  ? null 
                  : const Color(0xFF374151),
              borderRadius: BorderRadius.circular(16),
              border: isPrimary 
                  ? null 
                  : Border.all(
                      color: const Color(0xFF4B5563),
                      width: 1,
                    ),
              boxShadow: isPrimary ? [
                BoxShadow(
                  color: _getCategoryColors(widget.category)[0].withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ] : null,
            ),
            child: Icon(
              icon,
              size: iconSize,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernButton({
    required VoidCallback onPressed,
    required String label,
    required IconData icon,
    required bool isPrimary,
    bool isLarge = false,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isLarge ? 16 : 12,
              vertical: isLarge ? 10 : 8,
            ),
            decoration: BoxDecoration(
              gradient: isPrimary 
                  ? LinearGradient(
                      colors: _getCategoryColors(widget.category),
                    )
                  : null,
              color: isPrimary 
                  ? null 
                  : const Color(0xFF374151),
              borderRadius: BorderRadius.circular(16),
              border: isPrimary 
                  ? null 
                  : Border.all(
                      color: const Color(0xFF4B5563),
                      width: 1,
                    ),
              boxShadow: isPrimary ? [
                BoxShadow(
                  color: _getCategoryColors(widget.category)[0].withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ] : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: isLarge ? 18 : 16,
                  color: Colors.white,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isLarge ? 14 : 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Color> _getCategoryColors(VerbCategory category) {
    switch (category) {
      case VerbCategory.daily:
        return [const Color(0xFFFF6B6B), const Color(0xFFEE5A52)]; // Красивый градиент для Daily
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

class _DailyCard extends StatefulWidget {
  @override
  State<_DailyCard> createState() => _DailyCardState();
}

class _DailyCardState extends State<_DailyCard>
    with TickerProviderStateMixin {
  Map<String, int>? _progress;
  bool _isLoading = true;
  bool _isHovered = false;
  late AnimationController _animationController;
  late AnimationController _scaleController;
  late AnimationController _glowController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _loadProgress();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    ));
    
    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
    
    // Запускаем анимацию появления
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _animationController.forward();
        _scaleController.forward();
        _glowController.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scaleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  Future<void> _loadProgress() async {
    try {
      // Сначала проверяем, нужно ли сбросить Daily квиз
      await ProgressStorage.checkAndResetDailyQuiz();
      
      // Затем загружаем прогресс
      final progress = await ProgressStorage.loadCategoryProgress(VerbCategory.daily);
      setState(() {
        _progress = progress;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToQuiz() async {
    // Анимация нажатия
    _scaleController.reverse().then((_) {
      _scaleController.forward();
    });
    
    await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            QuizScreen(category: VerbCategory.daily),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;
          
          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );
          
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
    
    // Перезагружаем прогресс после возвращения из квиза
    await _loadProgress();
  }

  Future<void> _resetProgress() async {
    await ProgressStorage.forceResetDailyQuiz();
    await _loadProgress();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Daily квиз сброшен'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: const Color(0xFF1A1A2E),
      ),
    );
    
    // Начинаем квиз после сброса прогресса
    _navigateToQuiz();
  }

  @override
  Widget build(BuildContext context) {
    final hasProgress = _progress != null && 
        (_progress!['totalQuestions']! > 0 || 
         _progress!['correctAnswers']! > 0 || 
         _progress!['wrongAnswers']! > 0);
    
    // Проверяем, завершен ли Daily квиз (100% прогресс)
    final isCompleted = hasProgress && _progress != null &&
        _progress!['totalQuestions']! >= _progress!['targetQuestions']!;

    return AnimatedBuilder(
      animation: Listenable.merge([_fadeAnimation, _scaleAnimation, _glowAnimation]),
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: MouseRegion(
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                transform: Matrix4.identity()
                  ..translate(0.0, _isHovered ? -8.0 : 0.0),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width > 600 ? 85 : 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: _getDailyColors()[0].withOpacity(0.2 * _glowAnimation.value),
                        blurRadius: _isHovered ? 30 : 20,
                        offset: Offset(0, _isHovered ? 12 : 8),
                        spreadRadius: _isHovered ? 4 : 2,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF1A1A2E),
                            _getDailyColors()[0].withOpacity(0.1),
                            const Color(0xFF16213E),
                          ],
                        ),
                        border: Border.all(
                          color: _getDailyColors()[0].withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: isCompleted ? null : _navigateToQuiz, // Отключаем клики для завершенных тайлов
                          borderRadius: BorderRadius.circular(24),
                          child: Padding(
                            padding: EdgeInsets.all(MediaQuery.of(context).size.width > 600 ? 12 : 8),
                            child: Row(
                              children: [
                                // Иконка Daily
                                AnimatedBuilder(
                                  animation: _glowAnimation,
                                  builder: (context, child) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width > 600 ? 45 : 35,
                                      height: MediaQuery.of(context).size.width > 600 ? 45 : 35,
                                      decoration: BoxDecoration(
                                        color: _getDailyColors()[0].withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: _getDailyColors()[0].withOpacity(0.5 * _glowAnimation.value),
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: _getDailyColors()[0].withOpacity(0.3 * _glowAnimation.value),
                                            blurRadius: 10,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.calendar_today,
                                          size: MediaQuery.of(context).size.width > 600 ? 20 : 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                
                                SizedBox(width: MediaQuery.of(context).size.width > 600 ? 12 : 8),
                                
                                // Контент
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Daily',
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.width > 600 ? 18 : 16,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: MediaQuery.of(context).size.width > 600 ? 1 : 0),
                                      Text(
                                        'Ежедневный квиз',
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.width > 600 ? 12 : 10,
                                          color: const Color(0xFF9CA3AF),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Кнопка или прогресс
                                if (_isLoading)
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width > 600 ? 28 : 24,
                                    height: MediaQuery.of(context).size.width > 600 ? 28 : 24,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                else if (isCompleted)
                                  _buildDailyCompletedButton()
                                else if (hasProgress)
                                  _buildDailyProgressButton()
                                else
                                  _buildDailyStartButton(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDailyStartButton() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width > 600 ? 16 : 12,
        vertical: MediaQuery.of(context).size.width > 600 ? 8 : 6,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _getDailyColors(),
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _getDailyColors()[0].withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.play_arrow,
            size: MediaQuery.of(context).size.width > 600 ? 16 : 14,
            color: Colors.white,
          ),
          const SizedBox(width: 6),
          Text(
            'Начать',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width > 600 ? 14 : 12,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyProgressButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${_progress!['totalQuestions']}/${_progress!['targetQuestions']}',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width > 600 ? 12 : 10,
            fontWeight: FontWeight.w700,
            color: _getDailyColors()[0],
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.width > 600 ? 1 : 0),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width > 600 ? 12 : 8,
            vertical: MediaQuery.of(context).size.width > 600 ? 6 : 4,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _getDailyColors(),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.play_arrow,
            size: MediaQuery.of(context).size.width > 600 ? 14 : 12,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildDailyCompletedButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${_progress!['totalQuestions']}/${_progress!['targetQuestions']}',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width > 600 ? 12 : 10,
                fontWeight: FontWeight.w700,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: MediaQuery.of(context).size.width > 600 ? 16 : 14,
            ),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.width > 600 ? 1 : 0),
        // Широкая кнопка рестарта
        SizedBox(
          width: MediaQuery.of(context).size.width > 600 ? 80 : 60,
          child: ElevatedButton(
            onPressed: _resetProgress,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: _getDailyColors()[0],
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: _getDailyColors()[0].withOpacity(0.5),
                  width: 1,
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > 600 ? 12 : 8,
                vertical: MediaQuery.of(context).size.width > 600 ? 6 : 4,
              ),
            ),
            child: Icon(
              Icons.refresh,
              size: MediaQuery.of(context).size.width > 600 ? 16 : 14,
              color: _getDailyColors()[0],
            ),
          ),
        ),
      ],
    );
  }

  List<Color> _getDailyColors() {
    return [const Color(0xFFFF6B6B), const Color(0xFFEE5A52)];
  }
}