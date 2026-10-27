import 'package:flutter_test/flutter_test.dart';
import 'package:course_explorer_v2/main.dart';
import 'package:course_explorer_v2/repositories/course_repository.dart';
import 'package:course_explorer_v2/services/course_api_service.dart';

void main() {
  testWidgets('Menampilkan identitas mahasiswa', (tester) async {
    final repository = CourseRepository(
      CourseApiService('https://course-api-pearl.vercel.app'),
    );

    await tester.pumpWidget(CourseExplorerApp(repository: repository));

    await tester.pump();

    expect(find.text('Ni Komang Trisna Cahyani'), findsOneWidget);
    expect(find.text('NIM: 2415051072'), findsOneWidget);
  });
}
