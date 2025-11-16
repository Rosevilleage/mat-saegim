import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';
import 'package:flutter_application_1/features/home/presentation/widgets/result_modal/result_modal_constants.dart';

/// 모달 액션 버튼들 위젯
class ModalActions extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final VoidCallback onFindNearby;
  final VoidCallback onReroll;

  const ModalActions({
    super.key,
    required this.fadeAnimation,
    required this.onFindNearby,
    required this.onReroll,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: fadeAnimation.value,
      child: Column(
        children: [
          // Find Nearby Button - iOS style primary
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onFindNearby,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(
                  vertical: ResultModalConstants.buttonVerticalPadding,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    ResultModalConstants.buttonBorderRadius,
                  ),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.location_on,
                    size: ResultModalConstants.closeButtonIconSize,
                    color: Colors.white,
                  ),
                  SizedBox(width: ResultModalConstants.buttonIconSpacing),
                  Text(
                    '근처 음식점 찾기',
                    style: TextStyle(
                      fontSize: ResultModalConstants.buttonFontSize,
                      fontWeight: ResultModalConstants.buttonFontWeight,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: ResultModalConstants.buttonSpacing),

          // Roll Again Button - iOS style secondary
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onReroll,
              style: ElevatedButton.styleFrom(
                backgroundColor: ResultModalConstants.closeButtonBackgroundColor,
                padding: const EdgeInsets.symmetric(
                  vertical: ResultModalConstants.buttonVerticalPadding,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    ResultModalConstants.buttonBorderRadius,
                  ),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.refresh,
                    size: ResultModalConstants.closeButtonIconSize,
                    color: Color(0xFF111827),
                  ),
                  SizedBox(width: ResultModalConstants.buttonIconSpacing),
                  Text(
                    '다시 뽑기',
                    style: TextStyle(
                      fontSize: ResultModalConstants.buttonFontSize,
                      fontWeight: ResultModalConstants.buttonFontWeight,
                      color: Color(0xFF111827),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

