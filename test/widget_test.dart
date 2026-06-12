// This is a basic Flutter widget test.
import 'package:flutter_test/flutter_test.dart';
import 'package:beauty_hall/main.dart';

void main() {
  testWidgets('Beauty Hall smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BeautyHallApp());
    expect(find.textContaining('Beauty Hall'), findsOneWidget);
  });
}
