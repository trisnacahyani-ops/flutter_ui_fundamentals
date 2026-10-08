import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'course_state.dart';
import 'models/course.dart';

const String studentName = 'Ni Komang Trisna Cahyani';
const String studentId = '2415051072';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseState(),
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
      title: 'Course Explorer - Tahap 8',
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
    // Mengambil CourseState dari Provider
    final courseState = context.watch<CourseState>();

    // ==============================================
    // DATA JSON
    // ==============================================

    const Map<String, dynamic> courseJson = {
      'code': 'PTI501',
      'title': 'Pemrograman Mobile',
      'credits': 3,
      'status': 'Aktif',
    };

    // ==============================================
    // MENGUBAH JSON MENJADI OBJECT COURSE
    // ==============================================

    final Course course = Course.fromJson(courseJson);

    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 8 - Model Course')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==============================================
            // IDENTITAS MAHASISWA
            // ==============================================

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

            // ==============================================
            // DATA COURSE
            // ==============================================
            const Text(
              'Data Course',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.school, size: 32),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            course.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 24),

                    Text(
                      'Kode Course: ${course.code}',
                      style: const TextStyle(fontSize: 16),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'SKS: ${course.credits}',
                      style: const TextStyle(fontSize: 16),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        const Text('Status: ', style: TextStyle(fontSize: 16)),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            course.status,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ==============================================
            // INFORMASI MODEL
            // ==============================================
            Card(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.code, color: Colors.white, size: 30),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Data JSON berhasil diubah menjadi '
                        'object Course menggunakan Course.fromJson().',
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

            const SizedBox(height: 24),

            // ==============================================
            // FAVORITE COURSE
            // ==============================================
            const Text(
              'Favorite Course',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Card(
              child: ListTile(
                leading: const Icon(Icons.school),
                title: Text(
                  course.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Kode: ${course.code}\n'
                  '${courseState.isFavorite(course.code) ? 'Course favorite' : 'Belum favorite'}',
                ),
                trailing: IconButton(
                  onPressed: () {
                    context.read<CourseState>().toggleFavorite(course.code);
                  },
                  icon: Icon(
                    courseState.isFavorite(course.code)
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ==============================================
            // CONSUMER
            // ==============================================
            Consumer<CourseState>(
              builder: (context, state, child) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.favorite, size: 28),
                        const SizedBox(width: 12),
                        Text(
                          'Total Favorite: ${state.favorites.length}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
