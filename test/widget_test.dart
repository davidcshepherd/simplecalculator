import 'package:flutter_test/flutter_test.dart';
import 'package:simplecalculator/main.dart';

void main() {
  testWidgets('adds and clears', (tester) async {
    await tester.pumpWidget(const CalculatorApp());
    for (final key in ['7', '+', '8', '=']) {
      await tester.tap(find.text(key).last);
      await tester.pump();
    }
    expect(find.text('15'), findsOneWidget);
    await tester.tap(find.text('AC'));
    await tester.pump();
    expect(find.text('0'), findsNWidgets(2));
  });

  testWidgets('handles division by zero', (tester) async {
    await tester.pumpWidget(const CalculatorApp());
    for (final key in ['9', '÷', '0', '=']) {
      await tester.tap(find.text(key).last);
      await tester.pump();
    }
    expect(find.text('Error'), findsOneWidget);
  });
}
