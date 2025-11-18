import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/widgets/icons.dart';
import 'package:flutter_application_1/core/utils/animation_utils.dart';

/// 통통 튀는 주사위 위젯
class BounceDiceWidget extends StatelessWidget {
  final Animation<double> animation;

  const BounceDiceWidget({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final bounceOffset = AnimationUtils.bounceValue(animation.value);
        return Transform.translate(
          offset: Offset(0, bounceOffset),
          child: Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              color: const Color(0xFF4F39F6),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 25,
                  offset: const Offset(0, 25),
                  spreadRadius: -12,
                ),
              ],
            ),
            child: const Center(child: DiceIcon(size: 64, color: Colors.white)),
          ),
        );
      },
    );
  }
}
