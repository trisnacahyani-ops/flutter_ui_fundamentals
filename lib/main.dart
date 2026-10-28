import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/course.dart';
import 'services/course_data_source.dart';
import 'services/course_api_service.dart';
import 'repositories/course_repository.dart';
import 'providers/course_provider.dart';
import 'screens/main_page.dart'; // Menggunakan main_page.dart sesuai project u

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Konfigurasi Base URL REST API
  const String apiBaseUrl = 'https://course-api-pearl.vercel.app';

  // Menerapkan Repository Pattern (DataSource -> Repository -> Provider)[cite: 1]
  final CourseDataSource dataSource = CourseApiService(apiBaseUrl);
  final repository = CourseRepository(dataSource);

  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(repository)..loadCourses(),
      child: const CourseExplorerApp(),
    ),
  );
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Data Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainPage(), // Mengarahkan ke MainPage
    );
  }
}
