import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';

import 'widgets/dice_roll/widgets/dice_cube.dart';

/// 정육면체를 정적으로 보여주는 테스트 화면
class TestDisplayScreen extends StatefulWidget {
  const TestDisplayScreen({super.key});

  @override
  State<TestDisplayScreen> createState() => _TestDisplayScreenState();
}

class _TestDisplayScreenState extends State<TestDisplayScreen> {
  static const _dragSensitivity = 0.01;

  double _rotationX = -0.2;
  double _rotationY = 0.7;
  final double _rotationZ = 0.2;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('test_display'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _rotationY += details.delta.dx * _dragSensitivity;
                  _rotationX -= details.delta.dy * _dragSensitivity;
                });
              },
              child: DiceCube(
                rotateX: _rotationX,
                rotateY: _rotationY,
                rotateZ: _rotationZ,
                scale: 1.2,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '정육면체 미리보기',
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '드래그하여 주사위를 회전해보세요',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
