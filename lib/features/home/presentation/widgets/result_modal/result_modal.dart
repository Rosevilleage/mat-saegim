import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/overshoot_curved_animation.dart';
import 'package:flutter_application_1/features/home/presentation/widgets/result_modal/result_modal_constants.dart';
import 'package:flutter_application_1/features/home/presentation/widgets/result_modal/widgets/modal_backdrop.dart';
import 'package:flutter_application_1/features/home/presentation/widgets/result_modal/widgets/modal_handle.dart';
import 'package:flutter_application_1/features/home/presentation/widgets/result_modal/widgets/modal_icon.dart';
import 'package:flutter_application_1/features/home/presentation/widgets/result_modal/widgets/modal_result.dart';
import 'package:flutter_application_1/features/home/presentation/widgets/result_modal/widgets/modal_actions.dart';
import 'package:flutter_application_1/features/home/presentation/widgets/result_modal/widgets/modal_close_button.dart';

/// 결과 모달 위젯 (iOS 스타일 bottom sheet)
class ResultModal extends StatefulWidget {
  final String menu;
  final VoidCallback onFindNearby;
  final VoidCallback onReroll;
  final VoidCallback onClose;

  const ResultModal({
    super.key,
    required this.menu,
    required this.onFindNearby,
    required this.onReroll,
    required this.onClose,
  });

  @override
  State<ResultModal> createState() => _ResultModalState();
}

class _ResultModalState extends State<ResultModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _iconScaleAnimation;
  late Animation<double> _iconRotateAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _textScaleAnimation;
  late Animation<double> _buttonFadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: ResultModalConstants.animationDuration,
      vsync: this,
    );

    // 슬라이드 애니메이션 (overshoot 효과 포함)
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(OvershootCurvedAnimation(parent: _controller));

    // 페이드 인 애니메이션
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    // 아이콘 스케일 애니메이션
    _iconScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          ResultModalConstants.iconAnimationStart,
          1.0,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    // 아이콘 회전 애니메이션
    _iconRotateAnimation = Tween<double>(
      begin: ResultModalConstants.iconRotationStart,
      end: ResultModalConstants.iconRotationEnd,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          ResultModalConstants.iconAnimationStart,
          1.0,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    // 텍스트 페이드 애니메이션
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          ResultModalConstants.textAnimationStart,
          1.0,
          curve: Curves.easeOut,
        ),
      ),
    );

    // 텍스트 스케일 애니메이션
    _textScaleAnimation = Tween<double>(
      begin: ResultModalConstants.textScaleStart,
      end: ResultModalConstants.textScaleEnd,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          ResultModalConstants.textScaleAnimationStart,
          1.0,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    // 버튼 페이드 애니메이션
    _buttonFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          ResultModalConstants.buttonAnimationStart,
          1.0,
          curve: Curves.easeOut,
        ),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleClose() {
    _controller.reverse().then((_) {
      widget.onClose();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final maxModalHeight = screenHeight * ResultModalConstants.maxHeightRatio;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // 높이 0에서 최대 높이까지 늘어나는 애니메이션 (overshoot 포함)
        final heightMultiplier = _slideAnimation.value.clamp(0.0, 1.1);
        final currentModalHeight = maxModalHeight * heightMultiplier;

        return Stack(
          children: [
            // Backdrop with blur
            ModalBackdrop(
              fadeAnimation: _fadeAnimation,
              onTap: _handleClose,
            ),

            // Modal Sheet
            Positioned(
              left: 0,
              right: 0,
              bottom: 0.0,
              child: Container(
                width: screenWidth > ResultModalConstants.maxWidth
                    ? ResultModalConstants.maxWidth
                    : screenWidth,
                height: currentModalHeight,
                margin: EdgeInsets.symmetric(
                  horizontal: screenWidth > ResultModalConstants.maxWidth
                      ? (screenWidth - ResultModalConstants.maxWidth) / 2
                      : 0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(
                      ResultModalConstants.modalBorderRadius,
                    ),
                    topRight: Radius.circular(
                      ResultModalConstants.modalBorderRadius,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: ResultModalConstants.backdropColor.withValues(
                        alpha: ResultModalConstants.shadowOpacity,
                      ),
                      blurRadius: ResultModalConstants.modalShadowBlur,
                      offset: ResultModalConstants.modalShadowOffset,
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    // 상단: Handle
                    const ModalHandle(),

                    // 가운데: Icon with animated entrance
                    ModalIcon(
                      scaleAnimation: _iconScaleAnimation,
                      rotateAnimation: _iconRotateAnimation,
                    ),

                    // 하단: Result와 Actions
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: ResultModalConstants.contentHorizontalPadding,
                          vertical: ResultModalConstants.contentVerticalPadding,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Result
                            ModalResult(
                              menu: widget.menu,
                              fadeAnimation: _textFadeAnimation,
                              scaleAnimation: _textScaleAnimation,
                            ),

                            const SizedBox(
                              height: ResultModalConstants.sectionSpacing,
                            ),

                            // Actions
                            ModalActions(
                              fadeAnimation: _buttonFadeAnimation,
                              onFindNearby: widget.onFindNearby,
                              onReroll: widget.onReroll,
                            ),

                            const SizedBox(
                              height: ResultModalConstants.sectionSpacing,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Close Button
                    ModalCloseButton(onClose: _handleClose),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

