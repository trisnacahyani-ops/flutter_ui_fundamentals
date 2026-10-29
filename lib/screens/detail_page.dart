import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import 'course_form_page.dart';

class DetailPage extends StatelessWidget {
  final Course course;

  const DetailPage({super.key, required this.course});

  Future<void> _confirmDelete(
    BuildContext context,
    Course currentCourse,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Course?'),
        content: Text(
          'Apakah kamu yakin ingin menghapus '
          '"${currentCourse.title}"? Data yang dihapus tidak dapat '
          'dikembalikan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final id = currentCourse.id;
    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID course tidak ditemukan.')),
      );
      return;
    }

    try {
      await context.read<CourseProvider>().deleteCourse(id, currentCourse.code);

      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Course berhasil dihapus.')));

      Navigator.pop(context);
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal menghapus course: $e')));
    }
  }

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
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text('Ni Komang Trisna Cahyani'),
              subtitle: Text('NIM: 2415051072'),
            ),
          ),
          const SizedBox(height: 16),
          const Icon(Icons.school, size: 80, color: Colors.black),
          const SizedBox(height: 16),
          Text(
            currentCourse.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
            onPressed: () {
              context.read<CourseProvider>().toggleFavorite(currentCourse.code);
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
            ),
            label: Text(
              isFavorite ? 'Hapus dari Favorite' : 'Tambahkan ke Favorite',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: provider.isSaving
                ? null
                : () => _confirmDelete(context, currentCourse),
            icon: const Icon(Icons.delete),
            label: const Text('Hapus Course'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }
}
