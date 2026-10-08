import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'course_state.dart';
import 'services/course_service.dart';

const String studentName = 'Ni Komang Trisna Cahyani';
const String studentId = '2415051072';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseState(CourseService())..loadCourses(),
      child: const CourseExplorerApp(),
    ),
  );
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer - Tahap 9',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final courseState = context.watch<CourseState>();

    if (courseState.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Tahap 9 - Course Service')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (courseState.errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Tahap 9 - Course Service')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(courseState.errorMessage!, textAlign: TextAlign.center),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 9 - Course Service')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Identitas Mahasiswa',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Nama: $studentName'),
                    Text('NIM: $studentId'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Daftar Course',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            ...courseState.courses.map((course) {
              final favorite = courseState.isFavorite(course.code);

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.school, size: 32),
                  title: Text(
                    course.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Kode: ${course.code}\n'
                    'SKS: ${course.credits}\n'
                    'Status: ${course.status}',
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      context.read<CourseState>().toggleFavorite(course.code);
                    },
                    icon: Icon(
                      favorite ? Icons.favorite : Icons.favorite_border,
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 8),

            Card(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.storage, color: Colors.white, size: 30),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Data course dibaca melalui '
                        'CourseService dari file JSON, '
                        'kemudian diubah menjadi object Course.',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.favorite, size: 28),
                    const SizedBox(width: 12),
                    Text(
                      'Total Favorite: '
                      '${courseState.favorites.length}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
