// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/app.dart';
import 'package:flutter_application_1/features/home/presentation/widgets/dice_roll_animation.dart';

void main() {
  testWidgets('홈 화면에서 주사위 버튼을 누르면 애니메이션이 나타난다', (tester) async {
    await tester.pumpWidget(const App());

    expect(find.text('오늘 뭐 먹지?'), findsOneWidget);
    expect(find.text('주사위를 던져 오늘의 메뉴를 골라보세요'), findsOneWidget);

    await tester.tap(find.text('주사위 던지기'));
    await tester.pump();

    expect(find.byType(DiceRollAnimation), findsOneWidget);
  });
}
