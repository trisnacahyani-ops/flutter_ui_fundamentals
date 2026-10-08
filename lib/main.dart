import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'course_state.dart';

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
      title: 'Course Explorer - Tahap 6',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    // Mengambil CourseState yang disediakan oleh Provider
    final courseState = context.watch<CourseState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 6 - Provider')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==============================================
            // IDENTITAS
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
            // DAFTAR COURSE
            // ==============================================
            const Text(
              'Daftar Course',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            // ==============================================
            // COURSE 1
            // ==============================================
            CourseCard(
              courseId: 'flutter',
              courseName: 'Flutter UI Fundamentals',
              isFavorite: courseState.isFavorite('flutter'),
              onFavoriteChanged: () {
                courseState.toggleFavorite('flutter');
              },
            ),

            const SizedBox(height: 12),

            // ==============================================
            // COURSE 2
            // ==============================================
            CourseCard(
              courseId: 'state',
              courseName: 'State Management',
              isFavorite: courseState.isFavorite('state'),
              onFavoriteChanged: () {
                courseState.toggleFavorite('state');
              },
            ),

            const SizedBox(height: 24),

            // ==============================================
            // JUMLAH FAVORITE
            // ==============================================
            Card(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.white, size: 32),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Total Favorite: ${courseState.favorites.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ==============================================
            // DAFTAR FAVORITE
            // ==============================================
            if (courseState.favorites.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Course Favorite:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...courseState.favorites.map((id) {
                        String name;

                        if (id == 'flutter') {
                          name = 'Flutter UI Fundamentals';
                        } else {
                          name = 'State Management';
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text('• $name'),
                        );
                      }),
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

// ======================================================
// COURSE CARD
// ======================================================

class CourseCard extends StatelessWidget {
  final String courseId;
  final String courseName;
  final bool isFavorite;
  final VoidCallback onFavoriteChanged;

  const CourseCard({
    super.key,
    required this.courseId,
    required this.courseName,
    required this.isFavorite,
    required this.onFavoriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.school),
        title: Text(
          courseName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          isFavorite
              ? 'Course ditambahkan ke favorite'
              : 'Course belum menjadi favorite',
        ),
        trailing: IconButton(
          onPressed: onFavoriteChanged,
          icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
        ),
      ),
    );
  }
}
