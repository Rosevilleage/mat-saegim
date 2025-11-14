import 'dart:math';

/// 메뉴 저장소 (도메인 레이어)
class MenuRepository {
  static const List<String> _menus = [
    '김치찌개',
    '된장찌개',
    '부대찌개',
    '순두부찌개',
    '비빔밥',
    '불고기',
    '삼겹살',
    '치킨',
    '피자',
    '파스타',
    '라면',
    '떡볶이',
    '족발',
    '보쌈',
    '냉면',
    '갈비탕',
    '설렁탕',
    '순대국',
    '닭갈비',
    '곱창',
  ];

  /// 랜덤 메뉴 선택
  static String selectRandomMenu() {
    final random = Random();
    return _menus[random.nextInt(_menus.length)];
  }

  /// 전체 메뉴 목록 조회
  static List<String> getAllMenus() {
    return List.unmodifiable(_menus);
  }
}

