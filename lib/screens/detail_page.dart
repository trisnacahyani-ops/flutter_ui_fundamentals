import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import 'course_form_page.dart';

class DetailPage extends StatelessWidget {
  final Course course;

  const DetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    final currentCourse = provider.courses.firstWhere(
      (item) => item.id == course.id,
      orElse: () => course,
    );

    final isFavorite = provider.isFavorite(currentCourse.code);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Course'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Edit Course',
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CourseFormPage(course: currentCourse),
                ),
              );

              if (!context.mounted) return;

              await context.read<CourseProvider>().loadCourses();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Identitas Mahasiswa',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Nama: Ni Komang Trisna Cahyani'),
                  Text('NIM: 2415051072'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Icon(Icons.school, size: 80, color: Colors.black),
          const SizedBox(height: 16),
          Text(
            currentCourse.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Kode Course'),
                  subtitle: Text(currentCourse.code),
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Jumlah SKS'),
                  subtitle: Text('${currentCourse.credits} SKS'),
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Status'),
                  subtitle: Text(currentCourse.status),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16),
            ),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CourseFormPage(course: currentCourse),
                ),
              );

              if (!context.mounted) return;

              await context.read<CourseProvider>().loadCourses();
            },
            icon: const Icon(Icons.edit),
            label: const Text('Edit Course'),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16),
            ),
            onPressed: () {
              context.read<CourseProvider>().toggleFavorite(
                    currentCourse.code,
                  );
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
            ),
            label: Text(
              isFavorite ? 'Hapus dari Favorite' : 'Tambahkan ke Favorite',
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              isFavorite
                  ? 'Course ini sudah menjadi favorite.'
                  : 'Course ini belum menjadi favorite.',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
