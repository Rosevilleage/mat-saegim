import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 주사위 아이콘 위젯
class DiceIcon extends StatelessWidget {
  final double size;
  final Color color;

  const DiceIcon({super.key, required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: SvgPicture.asset(
        'assets/icons/dice_icon.svg',
        width: size,
        height: size,
        colorFilter: ColorFilter.mode(color, BlendMode.srcATop),
      ),
    );
  }
}

/// 홈 아이콘
class HomeIcon extends StatelessWidget {
  final double size;
  final Color color;

  const HomeIcon({super.key, required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: SvgPicture.asset(
        'assets/icons/home_icon.svg',
        width: size,
        height: size,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
}

/// 지도 아이콘
class MapIcon extends StatelessWidget {
  final double size;
  final Color color;

  const MapIcon({super.key, required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: SvgPicture.asset(
        'assets/icons/map_Icon.svg',
        width: size,
        height: size,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
}

/// 내정보 아이콘
class PersonIcon extends StatelessWidget {
  final double size;
  final Color color;

  const PersonIcon({super.key, required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: SvgPicture.asset(
        'assets/icons/person_icon.svg',
        width: size,
        height: size,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
}

