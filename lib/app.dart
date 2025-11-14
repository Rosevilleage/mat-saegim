import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/home_screen.dart';

/// 앱 루트 위젯
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '맛새김',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}

