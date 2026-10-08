import 'package:flutter_test/flutter_test.dart';
import 'package:course_explorer_v2/main.dart';

void main() {
  testWidgets('Course Explorer dapat dijalankan', (WidgetTester tester) async {
    await tester.pumpWidget(const CourseExplorerApp());

    expect(find.text('Course Explorer - Tahap 1'), findsOneWidget);
  });
}
