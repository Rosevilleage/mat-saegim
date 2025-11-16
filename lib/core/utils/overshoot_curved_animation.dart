import 'package:flutter/material.dart';

/// Overshoot 효과를 주는 커스텀 애니메이션
/// forward: 0 → 0.95 (거의 다) → 1.1 (overshoot) → 1.0 (최종)
/// reverse: 1.0 → 1.05 (overshoot) → 0.0
class OvershootCurvedAnimation extends Animation<double> {
  OvershootCurvedAnimation({required this.parent});

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
