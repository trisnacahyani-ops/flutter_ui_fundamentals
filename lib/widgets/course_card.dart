import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../screens/course_form_page.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final bool isFavorite;
  final VoidCallback? onFavoritePressed;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback?
  onTap; // Menyesuaikan dengan pemanggilan di main_page.dart

  const CourseCard({
    super.key,
    required this.course,
    this.isFavorite = false,
    this.onFavoritePressed,
    this.onFavoriteToggle,
    this.onTap,
  });

  // Fungsi untuk menampilkan dialog konfirmasi hapus (Tahap 8)
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text(
            'Apakah anda yakin ingin menghapus course "${course.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                Navigator.pop(dialogContext);

                try {
                  await context.read<CourseProvider>().deleteCourse(
                    course.id!,
                    course.code,
                  );

                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Course berhasil dihapus!')),
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menghapus: $e')),
                  );
                }
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final toggleAction = onFavoritePressed ?? onFavoriteToggle;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: ListTile(
        onTap: onTap, // Menghubungkan fungsi tap ke ListTile
        title: Text(
          course.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Kode: ${course.code} • ${course.credits} SKS\nStatus: ${course.status}',
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tombol Favorite
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              onPressed: toggleAction,
            ),
            // Tombol Edit (Tahap 7)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseFormPage(course: course),
                  ),
                );
              },
            ),
            // Tombol Hapus / Delete (Tahap 8)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}
