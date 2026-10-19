import 'package:flutter_test/flutter_test.dart';

import 'package:simple_image_editor_example/main.dart';

void main() {
  testWidgets('home page renders and editing is disabled without a photo', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Take a photo'), findsOneWidget);
    expect(find.text('Edit photo'), findsOneWidget);

    // Tapping edit without a photo must not throw
    await tester.tap(find.text('Edit photo'));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
