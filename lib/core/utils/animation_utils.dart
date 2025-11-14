import 'dart:math' as math;

/// 애니메이션 유틸리티
class AnimationUtils {
  /// cubic-bezier(0.8, 0, 1, 1) - ease-out
  static double easeOutCubic(double t) {
    return 1 - math.pow(1 - t, 3).toDouble();
  }

  /// cubic-bezier(0, 0, 0.2, 1) - ease-in
  static double easeInCubic(double t) {
    return t * t * t;
  }

  /// Tailwind CSS animate-bounce 값 계산
  /// keyframes:
  ///   0%, 100%: translateY(-25%) with cubic-bezier(0.8, 0, 1, 1)
  ///   50%: translateY(0) with cubic-bezier(0, 0, 0.2, 1)
  static double bounceValue(double animationValue) {
    if (animationValue < 0.5) {
      // 0.0 -> 0.5: -25%에서 0으로 (아래로 떨어짐)
      final t = animationValue * 2; // 0 ~ 1로 정규화
      final eased = easeInCubic(t);
      return -32 + (32 * eased); // -32px -> 0px (128px 기준 -25%)
    } else {
      // 0.5 -> 1.0: 0에서 -25%로 (위로 올라감)
      final t = (animationValue - 0.5) * 2; // 0 ~ 1로 정규화
      final eased = easeOutCubic(t);
      return 0 - (32 * eased); // 0px -> -32px
    }
  }
}

