import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'screens/main_page.dart';
import 'services/course_api_service.dart';

void main() {
  final repository = CourseRepository(
    CourseApiService(baseUrl: 'https://course-api-pearl.vercel.app'),
  );

  runApp(CourseExplorerApp(repository: repository));
}

class CourseExplorerApp extends StatelessWidget {
  final CourseRepository repository;

  const CourseExplorerApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CourseProvider(repository)..loadCourses(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Course Explorer',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
        ),
        home: const MainPage(),
      ),
    );
  }
}
