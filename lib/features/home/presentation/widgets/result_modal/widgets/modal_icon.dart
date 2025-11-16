import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';
import 'package:flutter_application_1/features/home/presentation/widgets/result_modal/result_modal_constants.dart';

/// 모달 중앙 아이콘 위젯 (애니메이션 포함)
class ModalIcon extends StatelessWidget {
  final Animation<double> scaleAnimation;
  final Animation<double> rotateAnimation;

  const ModalIcon({
    super.key,
    required this.scaleAnimation,
    required this.rotateAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: ResultModalConstants.iconTopOffset,
      bottom: ResultModalConstants.iconBottomOffset,
      left: 0,
      right: 0,
      child: Center(
        child: Transform.scale(
          scale: scaleAnimation.value,
          child: Transform.rotate(
            angle: rotateAnimation.value,
            child: Container(
              width: ResultModalConstants.iconSize,
              height: ResultModalConstants.iconSize,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6366F1), // indigo-500
                    AppTheme.primaryColor, // indigo-600
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(
                      alpha: ResultModalConstants.shadowOpacity,
                    ),
                    blurRadius: ResultModalConstants.iconShadowBlur,
                    offset: ResultModalConstants.iconShadowOffset,
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_awesome,
                size: ResultModalConstants.iconInnerSize,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

