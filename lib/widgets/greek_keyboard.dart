import 'package:flutter/material.dart';

class GreekKeyboard extends StatefulWidget {
  final Function(String) onKeyPressed;

  const GreekKeyboard({
    super.key,
    required this.onKeyPressed,
  });

  @override
  State<GreekKeyboard> createState() => _GreekKeyboardState();
}

class _GreekKeyboardState extends State<GreekKeyboard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _glowController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  
  // Отслеживание нажатых клавиш
  final Set<String> _pressedKeys = <String>{};

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
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
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
    
    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.forward();
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFF374151),
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
                children: [
                  // Первый ряд - греческая раскладка (аналог QWERTY)
                  _buildKeyRow([
                    ';', 'ς', 'ε', 'ρ', 'τ', 'υ', 'θ', 'ι', 'ο', 'π'
                  ]),
                  const SizedBox(height: 8),
                  // Второй ряд - греческая раскладка (аналог ASDF)
                  _buildKeyRow([
                    'α', 'σ', 'δ', 'φ', 'γ', 'η', 'ξ', 'κ', 'λ'
                  ]),
                  const SizedBox(height: 8),
                  // Третий ряд - греческая раскладка (аналог ZXCV)
                  _buildKeyRow([
                    'ζ', 'χ', 'ψ', 'ω', 'β', 'ν', 'μ'
                  ]),
                  const SizedBox(height: 12),
                  // Функциональные клавиши
                  Row(
                    children: [
                      Expanded(
                        child: _buildSpecialKey('Backspace', Icons.backspace_outlined),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 3,
                        child: _buildSpecialKey(' ', Icons.space_bar),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildSpecialKey('΄', Icons.keyboard_arrow_up),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildKeyRow(List<String> keys) {
    return Row(
      children: keys.map((key) => Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: _buildKey(key),
        ),
      )).toList(),
    );
  }

  Widget _buildKey(String key) {
    final bool isPressed = _pressedKeys.contains(key);
    
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTapDown: (_) {
            setState(() {
              _pressedKeys.add(key);
            });
          },
          onTapUp: (_) {
            setState(() {
              _pressedKeys.remove(key);
            });
            widget.onKeyPressed(key);
          },
          onTapCancel: () {
            setState(() {
              _pressedKeys.remove(key);
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                decoration: BoxDecoration(
                  color: isPressed ? const Color(0xFF4B5563) : const Color(0xFF374151),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isPressed ? const Color(0xFF6B7280) : const Color(0xFF4B5563),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isPressed 
                          ? Colors.black.withOpacity(0.4)
                          : Colors.black.withOpacity(0.2),
                      blurRadius: isPressed ? 2 : 4,
                      offset: Offset(0, isPressed ? 1 : 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    key,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isPressed ? const Color(0xFFE5E7EB) : Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialKey(String key, IconData icon) {
    Color backgroundColor;
    Color textColor;
    Color borderColor;
    List<Color> gradientColors;
    
    if (key == '΄') {
      backgroundColor = const Color(0xFF374151);
      textColor = const Color(0xFFF59E0B);
      borderColor = const Color(0xFFF59E0B);
      gradientColors = [const Color(0xFFF59E0B), const Color(0xFFD97706)];
    } else if (key == 'Backspace') {
      backgroundColor = const Color(0xFF374151);
      textColor = const Color(0xFFEF4444);
      borderColor = const Color(0xFFEF4444);
      gradientColors = [const Color(0xFFEF4444), const Color(0xFFDC2626)];
    } else {
      backgroundColor = const Color(0xFF374151);
      textColor = const Color(0xFF9CA3AF);
      borderColor = const Color(0xFF4B5563);
      gradientColors = [const Color(0xFF6B7280), const Color(0xFF4B5563)];
    }
    
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => widget.onKeyPressed(key),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: key == ' ' ? null : LinearGradient(
                    colors: gradientColors.map((color) => 
                      color.withOpacity(0.2 + 0.1 * _glowAnimation.value)
                    ).toList(),
                  ),
                  color: key == ' ' ? backgroundColor : null,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: borderColor.withOpacity(0.5 + 0.3 * _glowAnimation.value),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: borderColor.withOpacity(0.2 * _glowAnimation.value),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (key == ' ' || key == '΄') ...[
                        Icon(icon, size: 18, color: textColor),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        key == ' ' ? 'Пробел' : key == '΄' ? '΄' : '',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      if (key == 'Backspace') Icon(icon, size: 18, color: textColor),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}