import 'package:flutter/material.dart';

/// 결과 모달 관련 상수
class ResultModalConstants {
  // 애니메이션 설정
  static const Duration animationDuration = Duration(milliseconds: 500);
  static const double maxHeightRatio = 0.6; // 화면 높이의 60%
  static const double maxWidth = 390.0;

  // 레이아웃 상수
  static const double handleTopPadding = 16.0;
  static const double handleWidth = 48.0;
  static const double handleHeight = 6.0;
  static const double iconTopOffset = 50.0;
  static const double iconBottomOffset = 280.0;
  static const double iconSize = 96.0;
  static const double iconInnerSize = 48.0;
  static const double contentHorizontalPadding = 24.0;
  static const double contentVerticalPadding = 8.0;
  static const double closeButtonPadding = 16.0;
  static const double closeButtonIconSize = 20.0;

  // 애니메이션 Interval
  static const double iconAnimationStart = 0.2;
  static const double textAnimationStart = 0.3;
  static const double textScaleAnimationStart = 0.4;
  static const double buttonAnimationStart = 0.5;

  // 아이콘 회전 애니메이션
  static const double iconRotationStart = -3.14159; // -π
  static const double iconRotationEnd = 0.0;

  // 텍스트 스케일 애니메이션
  static const double textScaleStart = 0.8;
  static const double textScaleEnd = 1.0;

  // 색상
  static const Color handleColor = Color(0xFFD1D5DB);
  static const Color closeButtonBackgroundColor = Color(0xFFF3F4F6);
  static const Color backdropColor = Colors.black;
  static const double backdropOpacity = 0.6;
  static const double shadowOpacity = 0.3;

  // Border Radius
  static const double handleBorderRadius = 3.0;
  static const double modalBorderRadius = 32.0;
  static const double resultBorderRadius = 16.0;
  static const double buttonBorderRadius = 16.0;
  static const double closeButtonBorderRadius = 20.0;

  // Shadow
  static const double modalShadowBlur = 20.0;
  static const Offset modalShadowOffset = Offset(0, -5);
  static const double iconShadowBlur = 20.0;
  static const Offset iconShadowOffset = Offset(0, 10);
  static const double resultShadowBlur = 15.0;
  static const Offset resultShadowOffset = Offset(0, 5);

  // Spacing
  static const double textSpacing = 12.0;
  static const double sectionSpacing = 32.0;
  static const double buttonSpacing = 12.0;
  static const double buttonIconSpacing = 12.0;

  // Text Styles
  static const double subtitleFontSize = 16.0;
  static const FontWeight subtitleFontWeight = FontWeight.w400;
  static const double menuFontSize = 24.0;
  static const FontWeight menuFontWeight = FontWeight.bold;
  static const double buttonFontSize = 16.0;
  static const FontWeight buttonFontWeight = FontWeight.w600;

  // Button Padding
  static const double buttonVerticalPadding = 16.0;
  static const double resultHorizontalPadding = 32.0;
  static const double resultVerticalPadding = 16.0;

  // Backdrop Blur
  static const double backdropBlurSigma = 10.0;
}

