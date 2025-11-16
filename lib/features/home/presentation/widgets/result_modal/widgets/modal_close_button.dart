import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';
import 'package:flutter_application_1/features/home/presentation/widgets/result_modal/result_modal_constants.dart';

/// 모달 닫기 버튼 위젯
class ModalCloseButton extends StatelessWidget {
  final VoidCallback onClose;

  const ModalCloseButton({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: ResultModalConstants.closeButtonPadding,
      right: ResultModalConstants.closeButtonPadding,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onClose,
          borderRadius: BorderRadius.circular(
            ResultModalConstants.closeButtonBorderRadius,
          ),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: ResultModalConstants.closeButtonBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.close,
              size: ResultModalConstants.closeButtonIconSize,
              color: AppTheme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

