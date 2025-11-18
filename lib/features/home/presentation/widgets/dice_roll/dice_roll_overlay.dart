import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 'widgets/dice_cube.dart';

/// 주사위 던지기 오버레이
///
/// - [isRolling]이 true가 되면 오버레이가 나타나고 애니메이션을 시작한다.
/// - 애니메이션이 끝나면 [onCompleted] 콜백을 호출하고 400ms 이후 자연스럽게 숨긴다.
class DiceRollOverlay extends StatefulWidget {
  const DiceRollOverlay({
    super.key,
    required this.isRolling,
    required this.onCompleted,
  });

  final bool isRolling;
  final VoidCallback onCompleted;

  @override
  State<DiceRollOverlay> createState() => _DiceRollOverlayState();
}

class _DiceRollOverlayState extends State<DiceRollOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _showDice = false;
  Timer? _hideTimer;

  static const _animationDuration = Duration(milliseconds: 2500);
  static const _fadeDuration = Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _animationDuration)
      ..addStatusListener(_handleStatusChanged);
  }

  @override
  void didUpdateWidget(DiceRollOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRolling && !oldWidget.isRolling) {
      _startRoll();
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _controller.removeStatusListener(_handleStatusChanged);
    _controller.dispose();
    super.dispose();
  }

  void _startRoll() {
    _hideTimer?.cancel();
    setState(() {
      _showDice = true;
    });
    _controller.forward(from: 0);
  }

  void _handleStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onCompleted();
      _hideTimer = Timer(_fadeDuration, () {
        if (mounted) {
          setState(() {
            _showDice = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_showDice) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      child: AnimatedOpacity(
        opacity: _controller.isAnimating ? 1 : 0,
        duration: _fadeDuration,
        child: ColoredBox(
          color: Colors.transparent,
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final progress = _controller.value;
                final screenSize = MediaQuery.sizeOf(context);

                // 주사위 위치 (포물선 궤적)
                final positionY = _keyframeValue(_positionKeyframes, progress);
                final rotateX = _degreesToRadians(
                  _keyframeValue(_rotateXKeyframes, progress),
                );
                final rotateY = _degreesToRadians(
                  _keyframeValue(_rotateYKeyframes, progress),
                );
                final rotateZ = _degreesToRadians(
                  _keyframeValue(_rotateZKeyframes, progress),
                );
                final scale = _keyframeValue(_scaleKeyframes, progress);

                // 그림자 계산 (주사위가 그림자 위치에 가까울수록 그림자가 크고 진해짐)
                // 주사위 실제 위치: screenSize.height / 2 + positionY (Center 위젯 기준)
                // 그림자 위치: screenSize.height * 0.08
                final diceY = screenSize.height / 2 + positionY;
                final shadowY = screenSize.height * 0.08;
                final distanceFromShadow = (diceY - shadowY).abs();

                // 최대 거리 설정 (주사위가 가장 멀리 있을 때의 거리)
                // positionY가 600일 때를 기준으로 계산
                final maxDistance = (screenSize.height / 2 + 600 - shadowY)
                    .abs();
                final shadowDistanceFactor =
                    1.0 - (distanceFromShadow / maxDistance).clamp(0.0, 1.0);

                // 그림자가 가까울수록 크고 진하게
                final shadowScale =
                    0.3 + (shadowDistanceFactor * 0.9); // 0.3 ~ 1.2
                final shadowOpacity =
                    0.1 + (shadowDistanceFactor * 0.5); // 0.1 ~ 0.6
                final shadowBlur = shadowDistanceFactor * 25.0; // 0 ~ 25

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // 그림자 (주사위 아래)
                    Positioned(
                      top: screenSize.height * 0.08,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: _DiceShadow(
                          scale: shadowScale,
                          opacity: shadowOpacity,
                          blur: shadowBlur,
                        ),
                      ),
                    ),
                    // 주사위
                    Transform.translate(
                      offset: Offset(0, positionY),
                      child: DiceCube(
                        rotateX: rotateX,
                        rotateY: rotateY,
                        rotateZ: rotateZ,
                        scale: scale,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// Animation keyframes ---------------------------------------------------------

// 더 자연스러운 포물선 궤적과 바운스 효과
const _keyframeTimes = <double>[0.0, 0.15, 0.4, 0.65, 0.8, 0.9, 0.95, 1.0];

// 포물선 궤적: 아래에서 위로 올라오고 바닥에서 튕김
const _positionKeyframes = <double>[600, 350, -80, 20, -10, 3, -2, 0];

// 더 빠르고 자연스러운 회전
const _rotateXKeyframes = <double>[0, 450, 1080, 1440, 1620, 1710, 1755, 1800];

const _rotateYKeyframes = <double>[0, 360, 720, 1080, 1260, 1350, 1395, 1440];

const _rotateZKeyframes = <double>[0, 270, 540, 810, 945, 1012, 1044, 1080];

// 스케일: 아래에서 작게 시작해서 위로 올라가며 커짐
const _scaleKeyframes = <double>[0.2, 0.5, 1.4, 0.9, 1.15, 0.98, 1.05, 1.0];

double _keyframeValue(List<double> values, double t) {
  assert(values.length == _keyframeTimes.length);
  for (var i = 1; i < _keyframeTimes.length; i++) {
    final startT = _keyframeTimes[i - 1];
    final endT = _keyframeTimes[i];
    if (t <= endT) {
      final segmentT = ((t - startT) / (endT - startT)).clamp(0.0, 1.0);
      // 아래에서 올라올 때는 easeOut (감속), 위에서 떨어질 때는 easeIn (가속)
      final curve = i <= 2 ? Curves.easeOut : Curves.easeIn;
      final eased = curve.transform(segmentT);
      return lerpDouble(values[i - 1], values[i], eased) ?? values[i];
    }
  }
  return values.last;
}

double _degreesToRadians(double degrees) => degrees * (math.pi / 180);

class _DiceShadow extends StatelessWidget {
  const _DiceShadow({
    required this.scale,
    required this.opacity,
    required this.blur,
  });

  final double scale;
  final double opacity;
  final double blur;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Opacity(
        opacity: opacity,
        child: Container(
          width: 140,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(70),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: blur,
                spreadRadius: blur * 0.3,
              ),
            ],
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.5,
              colors: [
                Color.fromRGBO(0, 0, 0, 0.5 * opacity),
                Color.fromRGBO(0, 0, 0, 0.2 * opacity),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
