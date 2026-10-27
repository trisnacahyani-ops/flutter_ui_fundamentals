import 'package:flutter/material.dart';

import 'repositories/course_repository.dart';
import 'services/course_api_service.dart';

void main() {
  const baseUrl = 'https://course-api-pearl.vercel.app';
  final apiService = CourseApiService(baseUrl);
  final repository = CourseRepository(apiService);

  runApp(CourseExplorerApp(repository: repository));
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key, required this.repository});

  final CourseRepository repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: CourseListPage(repository: repository),
    );
  }
}

class CourseListPage extends StatefulWidget {
  const CourseListPage({super.key, required this.repository});

  final CourseRepository repository;

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  List<dynamic> courses = [];
  String errorMessage = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCourses();
  }

  Future<void> loadCourses() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final result = await widget.repository.getCourses();

      if (!mounted) return;
      setState(() {
        courses = result;
        isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        errorMessage = error.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Mata Kuliah')),
      body: Column(
        children: [
          const Card(
            margin: EdgeInsets.all(12),
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text('Ni Komang Trisna Cahyani'),
              subtitle: Text('NIM: 2415051072'),
            ),
          ),
          if (isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (errorMessage.isNotEmpty)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Gagal mengambil data:\n$errorMessage'),
                ),
              ),
            )
          else
            Expanded(
              child: RefreshIndicator(
                onRefresh: loadCourses,
                child: ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(course.credits.toString()),
                        ),
                        title: Text('${course.code} - ${course.title}'),
                        subtitle: Text('Status: ${course.status}'),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: loadCourses,
        tooltip: 'Muat ulang data',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
