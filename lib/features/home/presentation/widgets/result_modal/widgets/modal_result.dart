import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';
import 'package:flutter_application_1/features/home/presentation/widgets/result_modal/result_modal_constants.dart';

/// 모달 결과 텍스트 위젯
class ModalResult extends StatelessWidget {
  final String menu;
  final Animation<double> fadeAnimation;
  final Animation<double> scaleAnimation;

  const ModalResult({
    super.key,
    required this.menu,
    required this.fadeAnimation,
    required this.scaleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: fadeAnimation.value,
      child: Column(
        children: [
          const Text(
            '오늘의 메뉴는',
            style: TextStyle(
              fontSize: ResultModalConstants.subtitleFontSize,
              fontWeight: ResultModalConstants.subtitleFontWeight,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: ResultModalConstants.textSpacing),
          Transform.scale(
            scale: scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: ResultModalConstants.resultHorizontalPadding,
                vertical: ResultModalConstants.resultVerticalPadding,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppTheme.primaryColor,
                    Color(0xFF6366F1),
                  ],
                ),
                borderRadius: BorderRadius.circular(
                  ResultModalConstants.resultBorderRadius,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(
                      alpha: ResultModalConstants.shadowOpacity,
                    ),
                    blurRadius: ResultModalConstants.resultShadowBlur,
                    offset: ResultModalConstants.resultShadowOffset,
                  ),
                ],
              ),
              child: Text(
                menu,
                style: const TextStyle(
                  fontSize: ResultModalConstants.menuFontSize,
                  fontWeight: ResultModalConstants.menuFontWeight,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

