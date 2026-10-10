import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'course_state.dart';
import 'repositories/course_repository.dart';
import 'services/course_service.dart';

const String studentName = 'Ni Komang Trisna Cahyani';
const String studentId = '2415051072';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) =>
          CourseState(CourseRepository(CourseService()))..loadCourses(),
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
      title: 'Course Explorer - Tahap 10',
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 10 - Repository Pattern'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: courseState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : courseState.errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  courseState.errorMessage!,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Identitas mahasiswa
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

                  // Judul daftar course
                  const Text(
                    'Daftar Course',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  // Data course dari repository
                  if (courseState.courses.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Belum ada data course.'),
                      ),
                    )
                  else
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
                          isThreeLine: true,
                          trailing: IconButton(
                            tooltip: favorite
                                ? 'Hapus dari favorite'
                                : 'Tambah ke favorite',
                            onPressed: () {
                              context.read<CourseState>().toggleFavorite(
                                course.code,
                              );
                            },
                            icon: Icon(
                              favorite ? Icons.favorite : Icons.favorite_border,
                              color: favorite ? Colors.red : Colors.black,
                            ),
                          ),
                        ),
                      );
                    }),

                  const SizedBox(height: 12),

                  // Keterangan Repository Pattern
                  Card(
                    color: Colors.black,
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.layers, color: Colors.white, size: 30),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'CourseState mengambil data '
                              'melalui CourseRepository. '
                              'Repository menjadi lapisan '
                              'abstraksi antara state dan '
                              'sumber data.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Total favorite
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
