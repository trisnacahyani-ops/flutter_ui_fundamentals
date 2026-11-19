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
  final VoidCallback? onTap;

  const CourseCard({
    super.key,
    required this.course,
    this.isFavorite = false,
    this.onFavoritePressed,
    this.onFavoriteToggle,
    this.onTap,
  });

  static const Color primaryPurple = Color(0xFF7956D8);

  Color _getStatusColor() {
    switch (course.status.toLowerCase()) {
      case 'planned':
        return Colors.orange;
      case 'active':
        return Colors.green;
      case 'done':
        return Colors.blue;
      default:
        return primaryPurple;
    }
  }

  IconData _getStatusIcon() {
    switch (course.status.toLowerCase()) {
      case 'planned':
        return Icons.event_note_rounded;
      case 'active':
        return Icons.play_circle_outline_rounded;
      case 'done':
        return Icons.check_circle_outline_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Row(
            children: [
              Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
              SizedBox(width: 10),
              Text(
                'Hapus Course?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          content: Text(
            'Apakah kamu yakin ingin menghapus course "${course.title}"? '
            'Data yang dihapus tidak dapat dikembalikan.',
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Colors.black54,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Batal',
                style: TextStyle(color: Colors.black54),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                Navigator.pop(dialogContext);

                if (course.id == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ID course tidak ditemukan.')),
                  );
                  return;
                }

                try {
                  await context.read<CourseProvider>().deleteCourse(
                    course.id!,
                    course.code,
                  );

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Course berhasil dihapus!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal menghapus course: $e'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
              child: const Text(
                'Hapus',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final toggleAction = onFavoritePressed ?? onFavoriteToggle;
    final statusColor = _getStatusColor();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.deepPurple.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFF0EBFA)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEDE5FF), Color(0xFFFCE7F3)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: primaryPurple,
                      size: 25,
                    ),
                  ),

                  const SizedBox(width: 13),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF30264A),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Kode: ${course.code}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    tooltip: isFavorite
                        ? 'Hapus dari favorite'
                        : 'Tambahkan ke favorite',
                    onPressed: toggleAction,
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: isFavorite ? const Color(0xFFE85D8E) : Colors.grey,
                      size: 23,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildInfoChip(
                    icon: Icons.numbers_rounded,
                    label: '${course.credits} SKS',
                    color: primaryPurple,
                  ),
                  _buildInfoChip(
                    icon: _getStatusIcon(),
                    label: course.status.toUpperCase(),
                    color: statusColor,
                  ),
                ],
              ),

              const SizedBox(height: 14),

              const Divider(height: 1, color: Color(0xFFF0EBFA)),

              const SizedBox(height: 8),

              Row(
                children: [
                  const Spacer(),

                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CourseFormPage(course: course),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: primaryPurple,
                      visualDensity: VisualDensity.compact,
                    ),
                    icon: const Icon(Icons.edit_rounded, size: 17),
                    label: const Text('Edit'),
                  ),

                  const SizedBox(width: 4),

                  TextButton.icon(
                    onPressed: () => _showDeleteDialog(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      visualDensity: VisualDensity.compact,
                    ),
                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                    label: const Text('Hapus'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
