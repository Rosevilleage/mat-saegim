import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_application_1/features/home/presentation/widgets/result_modal/result_modal_constants.dart';

/// 모달 배경 블러 위젯
class ModalBackdrop extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final VoidCallback onTap;

  const ModalBackdrop({
    super.key,
    required this.fadeAnimation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: ResultModalConstants.backdropColor.withValues(
          alpha: ResultModalConstants.backdropOpacity * fadeAnimation.value,
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: ResultModalConstants.backdropBlurSigma,
            sigmaY: ResultModalConstants.backdropBlurSigma,
          ),
          child: Container(color: Colors.transparent),
        ),
      ),
    );
  }
}

