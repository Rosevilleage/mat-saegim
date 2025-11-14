import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_application_1/core/widgets/icons.dart';

/// 주사위 던지기 애니메이션 위젯
class DiceRollAnimation extends StatelessWidget {
  final Animation<double> animation;

  const DiceRollAnimation({
    super.key,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;

        // 화면 위에서 시작하여 중앙으로 떨어지는 애니메이션
        final startY = -200.0;
        final endY = screenHeight * 0.4;
        final currentY = startY + (endY - startY) * animation.value;

        // 회전 애니메이션
        final rotation = animation.value * 4 * math.pi;

        // 스케일 애니메이션
        final scale = 0.5 + (animation.value * 0.5);

        return Positioned(
          left: screenWidth / 2 - 64,
          top: currentY,
          child: Transform.scale(
            scale: scale,
            child: Transform.rotate(
              angle: rotation,
              child: Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  color: const Color(0xFF4F39F6),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Center(
                  child: DiceIcon(size: 64, color: Colors.white),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

