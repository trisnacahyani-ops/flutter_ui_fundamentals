import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import '../widgets/student_identity_card.dart';

const String studentName = 'Ni Komang Trisna Cahyani';
const String studentId = '2415051072';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 12 - Refactor Folder'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StudentIdentityCard(name: studentName, id: studentId),

            const SizedBox(height: 24),

            const Text(
              'Daftar Course',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            if (provider.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(color: Colors.black),
                ),
              )
            else if (provider.error != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 40,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Gagal memuat data:\n${provider.error}',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          context.read<CourseProvider>().loadCourses();
                        },
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              )
            else if (provider.courses.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Belum ada data course.'),
                ),
              )
            else
              ...provider.courses.map((course) {
                return CourseCard(
                  course: course,
                  isFavorite: provider.isFavorite(course.code),
                  onFavoritePressed: () {
                    context.read<CourseProvider>().toggleFavorite(course.code);
                  },
                );
              }),

            const SizedBox(height: 12),

            Card(
              color: Colors.black,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.folder_copy, color: Colors.white, size: 30),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Struktur aplikasi dipisahkan '
                        'berdasarkan tanggung jawab. '
                        'Models mengelola data, services '
                        'memuat data, repositories '
                        'menghubungkan sumber data, '
                        'providers mengelola state, '
                        'screens mengatur halaman, dan '
                        'widgets menyimpan komponen UI.',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.favorite, color: Colors.red),
                title: const Text('Total Favorite'),
                trailing: Text(
                  '${provider.favorites.length}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            Center(
              child: TextButton.icon(
                onPressed: provider.isLoading
                    ? null
                    : () {
                        context.read<CourseProvider>().loadCourses();
                      },
                icon: const Icon(Icons.refresh),
                label: const Text('Muat Ulang Course'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
