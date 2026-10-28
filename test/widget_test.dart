import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:course_explorer_v2/services/course_api_service.dart';
import 'package:course_explorer_v2/repositories/course_repository.dart';
import 'package:course_explorer_v2/providers/course_provider.dart';
import 'package:course_explorer_v2/screens/main_page.dart';

void main() {
  testWidgets('Course Explorer smoke test', (WidgetTester tester) async {
    // Inisialisasi dummy / mock dependencies untuk test
    final dataSource = CourseApiService('https://course-api-pearl.vercel.app');
    final repository = CourseRepository(dataSource);

    // Build aplikasi dengan membungkusnya menggunakan Provider
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => CourseProvider(repository),
        child: const MaterialApp(home: MainPage()),
      ),
    );

    // Verifikasi dasar bahwa aplikasi berhasil dimuat
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
