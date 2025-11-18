import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

const double _diceCubeSize = 112.0;
const double _diceCubeHalf = _diceCubeSize / 2;

/// 3D 정육면체 주사위 위젯.
///
/// [rotateX]/[rotateY]/[rotateZ]를 이용해 원하는 각도로 기울일 수 있으며
/// [scale]을 통해 크기를 조정할 수 있다.
class DiceCube extends StatelessWidget {
  const DiceCube({
    super.key,
    this.rotateX = 0,
    this.rotateY = 0,
    this.rotateZ = 0,
    this.scale = 1,
  });

  final double rotateX;
  final double rotateY;
  final double rotateZ;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final baseTransform = Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..rotateX(rotateX)
      ..rotateY(rotateY)
      ..rotateZ(rotateZ)
      ..scaleByDouble(scale, scale, scale, 1);

    final faces = _buildFaces(baseTransform);

    return SizedBox(
      width: _diceCubeSize,
      height: _diceCubeSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (final face in faces)
            Transform(
              alignment: Alignment.center,
              transform: face.transform,
              child: _CubeFace(color: face.color, label: face.label),
            ),
        ],
      ),
    );
  }

  List<_FaceRenderData> _buildFaces(Matrix4 baseTransform) {
    final definitions = _FaceDefinition.definitions;

    final faces = <_FaceRenderData>[];

    for (final definition in definitions) {
      final transform = baseTransform.clone()..multiply(definition.transform);
      final depth = _depthOf(transform);
      faces.add(
        _FaceRenderData(
          label: definition.label,
          color: definition.color,
          transform: transform,
          depth: depth,
        ),
      );
    }

    faces.sort((a, b) => a.depth.compareTo(b.depth));
    return faces;
  }

  double _depthOf(Matrix4 transform) {
    final origin = vm.Vector3.zero();
    transform.transform3(origin);
    return origin.z;
  }
}

class _CubeFace extends StatelessWidget {
  const _CubeFace({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.4),
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 20, spreadRadius: 2),
        ],
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }
}

class _FaceRenderData {
  _FaceRenderData({
    required this.label,
    required this.color,
    required this.transform,
    required this.depth,
  });

  final String label;
  final Color color;
  final Matrix4 transform;
  final double depth;
}

class _FaceDefinition {
  const _FaceDefinition({
    required this.color,
    required this.label,
    required this.transform,
  });

  final Color color;
  final String label;
  final Matrix4 transform;

  static List<_FaceDefinition> get definitions => [
    _FaceDefinition(
      color: const Color(0xFFFFB6C1),
      label: '??',
      transform: Matrix4.identity()
        ..translateByDouble(0.0, 0.0, _diceCubeHalf, 1),
    ),
    _FaceDefinition(
      color: const Color(0xFFC8BFE7),
      label: '????',
      transform: Matrix4.identity()
        ..translateByDouble(0.0, 0.0, -_diceCubeHalf, 1)
        ..rotateY(math.pi),
    ),
    _FaceDefinition(
      color: const Color(0xFFBDE0D7),
      label: '?',
      transform: Matrix4.identity()
        ..rotateX(math.pi / 2)
        ..translateByDouble(0.0, 0.0, _diceCubeHalf, 1),
    ),
    _FaceDefinition(
      color: const Color(0xFFFFDAB9),
      label: '???',
      transform: Matrix4.identity()
        ..rotateX(-math.pi / 2)
        ..translateByDouble(0.0, 0.0, _diceCubeHalf, 1),
    ),
    _FaceDefinition(
      color: const Color(0xFFADD8E6),
      label: '??',
      transform: Matrix4.identity()
        ..rotateY(math.pi / 2)
        ..translateByDouble(0.0, 0.0, _diceCubeHalf, 1),
    ),
    _FaceDefinition(
      color: const Color(0xFFDEEECC),
      label: '?',
      transform: Matrix4.identity()
        ..rotateY(-math.pi / 2)
        ..translateByDouble(0.0, 0.0, _diceCubeHalf, 1),
    ),
  ];
}
