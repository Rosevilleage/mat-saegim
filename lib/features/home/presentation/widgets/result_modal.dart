import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_application_1/core/theme/app_theme.dart';

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
      // 더 자연스러운 spring 느낌을 위해 약간 더 길게
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // ✅ 슬라이드 값은 0.0 ~ 1.0로 정규화해서 쓴다
    // spring 느낌을 내고 싶으면 easeOutBack 사용
    // overshoot 효과를 위해 커스텀 curve 사용
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_OvershootCurvedAnimation(parent: _controller));

    // 페이드 인 애니메이션
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    // 아이콘 스케일 애니메이션 (delay: 0.2s)
    _iconScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutBack),
      ),
    );

    // 아이콘 회전 애니메이션 (delay: 0.2s)
    _iconRotateAnimation = Tween<double>(begin: -3.14159, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutBack),
      ),
    );

    // 텍스트 페이드 애니메이션 (delay: 0.3s)
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    // 텍스트 스케일 애니메이션 (delay: 0.4s)
    _textScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutBack),
      ),
    );

    // 버튼 페이드 애니메이션 (delay: 0.5s)
    _buttonFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
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
    final maxModalHeight = screenHeight * 0.6; // 최대 높이: 화면의 60%

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // 높이 0에서 화면의 60%까지 늘어나는 애니메이션 (overshoot 포함)
        // _slideAnimation.value가 1.0을 초과할 수 있음 (overshoot)
        final heightMultiplier = _slideAnimation.value.clamp(0.0, 1.1);
        final currentModalHeight = maxModalHeight * heightMultiplier;

        // 모달이 화면 하단에 붙어있도록
        final bottomOffset = 0.0;

        return Stack(
          children: [
            // Backdrop with blur
            GestureDetector(
              onTap: _handleClose,
              child: Container(
                color: Colors.black.withOpacity(0.6 * _fadeAnimation.value),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),

            // Modal Sheet
            Positioned(
              left: 0,
              right: 0,
              bottom: bottomOffset,
              child: Container(
                width: screenWidth > 390 ? 390 : screenWidth,
                height: currentModalHeight,
                margin: EdgeInsets.symmetric(
                  horizontal: screenWidth > 390 ? (screenWidth - 390) / 2 : 0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    // 상단: Handle
                    Positioned(
                      top: 16,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: 48,
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD1D5DB),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),

                    // handle과 하단 사이의 가운데: Icon with animated entrance
                    Positioned(
                      top: 50, // handle 아래 (16 + 6 + 12 + 여유공간)
                      bottom: 280, // 하단 위젯 위 (대략적인 높이)
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Transform.scale(
                          scale: _iconScaleAnimation.value,
                          child: Transform.rotate(
                            angle: _iconRotateAnimation.value,
                            child: Container(
                              width: 96,
                              height: 96,
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
                                    color: AppTheme.primaryColor.withOpacity(
                                      0.3,
                                    ),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.auto_awesome,
                                size: 48,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 하단: Result와 Actions를 하단에 고정
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Result
                            Opacity(
                              opacity: _textFadeAnimation.value,
                              child: Column(
                                children: [
                                  const Text(
                                    '오늘의 메뉴는',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Transform.scale(
                                    scale: _textScaleAnimation.value,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 32,
                                        vertical: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            AppTheme.primaryColor,
                                            Color(0xFF6366F1),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppTheme.primaryColor
                                                .withOpacity(0.3),
                                            blurRadius: 15,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        widget.menu,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Actions
                            Opacity(
                              opacity: _buttonFadeAnimation.value,
                              child: Column(
                                children: [
                                  // Find Nearby Button - iOS style primary
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: widget.onFindNearby,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTheme.primaryColor,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        elevation: 2,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.location_on,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 12),
                                          Text(
                                            '근처 음식점 찾기',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  // Roll Again Button - iOS style secondary
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: widget.onReroll,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFFF3F4F6,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.refresh,
                                            size: 20,
                                            color: Color(0xFF111827),
                                          ),
                                          SizedBox(width: 12),
                                          Text(
                                            '다시 뽑기',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF111827),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),

                    // Close Button
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _handleClose,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF3F4F6),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 20,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
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

/// Overshoot 효과를 주는 커스텀 애니메이션
/// forward: 0 → 0.95 (거의 다) → 1.1 (overshoot) → 1.0 (최종)
/// reverse: 1.0 → 1.05 (overshoot) → 0.0
class _OvershootCurvedAnimation extends Animation<double> {
  _OvershootCurvedAnimation({required this.parent});

  final AnimationController parent;

  @override
  double get value {
    final t = parent.value;
    if (parent.status == AnimationStatus.forward ||
        parent.status == AnimationStatus.completed) {
      // 올라올 때 (forward)
      return _forwardCurve(t);
    } else {
      // 내려갈 때 (reverse)
      return _reverseCurve(1.0 - t);
    }
  }

  @override
  AnimationStatus get status => parent.status;

  @override
  void addListener(VoidCallback listener) => parent.addListener(listener);

  @override
  void removeListener(VoidCallback listener) => parent.removeListener(listener);

  @override
  void addStatusListener(AnimationStatusListener listener) =>
      parent.addStatusListener(listener);

  @override
  void removeStatusListener(AnimationStatusListener listener) =>
      parent.removeStatusListener(listener);

  double _forwardCurve(double t) {
    // t: 0.0 ~ 1.0
    if (t < 0.9) {
      // 0.0 ~ 0.9: 빠르게 1.05까지 easeOut으로 올라감
      final normalized = t / 0.9; // 0 ~ 1
      // easeOutCubic: 1 - (1 - x)^3
      final eased = 1 - (1 - normalized) * (1 - normalized) * (1 - normalized);
      return eased * 1.05; // 최대값 1.05까지
    } else {
      // 0.9 ~ 1.0: 1.05 → 1.0으로 살짝 되돌아옴
      final normalized = (t - 0.9) / 0.1; // 0 ~ 1
      // easeInQuadratic
      final eased = normalized * normalized;
      return 1.05 - 0.05 * eased;
    }
  }

  double _reverseCurve(double t) {
    // t는 0.0 ~ 1.0 (reverse에서는 1.0에서 시작해서 0.0으로 감소)
    if (t < 0.08) {
      // 0 ~ 0.08: overshoot (1.0 → 1.04)
      final normalized = t / 0.08;
      final eased = normalized * normalized; // easeIn
      return 1.0 + (0.04 * eased);
    } else if (t < 0.25) {
      // 0.08 ~ 0.25: 다시 1.0으로 돌아옴 (1.04 → 1.0)
      final normalized = (t - 0.08) / 0.17;
      // easeOut으로 부드럽게
      final eased = 1 - (1 - normalized) * (1 - normalized);
      return 1.04 - (0.04 * eased);
    } else {
      // 0.25 ~ 1.0: 아래로 사라짐 (1.0 → 0.0)
      final normalized = (t - 0.25) / 0.75;
      // easeIn으로 빠르게 사라짐
      final eased = normalized * normalized;
      return 1.0 - eased;
    }
  }
}
