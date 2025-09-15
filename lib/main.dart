import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const GreekQuizApp());
}

class GreekQuizApp extends StatelessWidget {
  const GreekQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Греческий Квиз',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
