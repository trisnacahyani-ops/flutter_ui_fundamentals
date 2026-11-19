import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import 'course_form_page.dart';

class DetailPage extends StatelessWidget {
  final Course course;

  const DetailPage({super.key, required this.course});

  static const Color purple = Color(0xFF7956D8);
  static const Color darkPurple = Color(0xFF493477);
  static const Color background = Color(0xFFF8F5FF);

  Future<void> _confirmDelete(
    BuildContext context,
    Course currentCourse,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
            SizedBox(width: 10),
            Text('Hapus Course?'),
          ],
        ),
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
              backgroundColor: Colors.redAccent,
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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Course berhasil dihapus.'),
          backgroundColor: Color(0xFF36B37E),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus course: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _editCourse(BuildContext context, Course currentCourse) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CourseFormPage(course: currentCourse)),
    );

    if (!context.mounted) return;

    await context.read<CourseProvider>().loadCourses();
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'planned':
        return const Color(0xFFEF9A42);
      case 'active':
        return const Color(0xFF36B37E);
      case 'done':
        return const Color(0xFF6388D8);
      default:
        return purple;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'planned':
        return Icons.schedule_rounded;
      case 'active':
        return Icons.play_circle_outline_rounded;
      case 'done':
        return Icons.check_circle_outline_rounded;
      default:
        return Icons.info_outline_rounded;
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
    final statusColor = _statusColor(currentCourse.status);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'Detail Course',
          style: TextStyle(color: darkPurple, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: background,
        foregroundColor: darkPurple,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Edit Course',
            icon: const Icon(Icons.edit_rounded, color: purple),
            onPressed: () => _editCourse(context, currentCourse),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 30),
        children: [
          _buildStudentCard(),
          const SizedBox(height: 22),

          _buildCourseHeader(currentCourse),
          const SizedBox(height: 24),

          const Text(
            'Informasi Course',
            style: TextStyle(
              color: darkPurple,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),

          _buildInformationCard(
            icon: Icons.qr_code_rounded,
            title: 'Kode Course',
            value: currentCourse.code,
            color: const Color(0xFFE9E0FF),
            iconColor: purple,
          ),
          const SizedBox(height: 12),

          _buildInformationCard(
            icon: Icons.menu_book_rounded,
            title: 'Jumlah SKS',
            value: '${currentCourse.credits} SKS',
            color: const Color(0xFFFFE5F0),
            iconColor: const Color(0xFFEC6FA5),
          ),
          const SizedBox(height: 12),

          _buildInformationCard(
            icon: _statusIcon(currentCourse.status),
            title: 'Status Course',
            value: currentCourse.status,
            color: statusColor.withValues(alpha: 0.12),
            iconColor: statusColor,
            valueColor: statusColor,
          ),
          const SizedBox(height: 26),

          const Text(
            'Kelola Course',
            style: TextStyle(
              color: darkPurple,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),

          _buildActionButton(
            icon: Icons.edit_rounded,
            label: 'Edit Course',
            description: 'Ubah informasi course',
            color: purple,
            onPressed: () => _editCourse(context, currentCourse),
          ),
          const SizedBox(height: 12),

          _buildActionButton(
            icon: isFavorite
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            label: isFavorite ? 'Hapus dari Favorite' : 'Tambahkan ke Favorite',
            description: 'Kelola daftar course favorit',
            color: const Color(0xFFEC6FA5),
            onPressed: () {
              context.read<CourseProvider>().toggleFavorite(currentCourse.code);
            },
          ),
          const SizedBox(height: 12),

          _buildActionButton(
            icon: Icons.delete_outline_rounded,
            label: 'Hapus Course',
            description: 'Hapus course dari daftar',
            color: const Color(0xFFE65C65),
            onPressed: provider.isSaving
                ? null
                : () => _confirmDelete(context, currentCourse),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEAE3FF)),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Color(0xFFFFE5F0),
            child: Icon(
              Icons.person_rounded,
              color: Color(0xFFEC6FA5),
              size: 28,
            ),
          ),
          SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ni Komang Trisna Cahyani',
                  style: TextStyle(
                    color: darkPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Pendidikan Teknik Informatika',
                  style: TextStyle(color: Color(0xFF9289A5), fontSize: 11),
                ),
              ],
            ),
          ),
          Icon(Icons.verified_rounded, color: purple),
        ],
      ),
    );
  }

  Widget _buildCourseHeader(Course currentCourse) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7956D8), Color(0xFFAA85F5), Color(0xFFCCB7FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: purple.withValues(alpha: 0.20),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.20),
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Icon(
              Icons.school_rounded,
              color: Colors.white,
              size: 49,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            currentCourse.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            'Course Code: ${currentCourse.code}',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _statusIcon(currentCourse.status),
                  size: 16,
                  color: _statusColor(currentCourse.status),
                ),
                const SizedBox(width: 7),
                Text(
                  currentCourse.status.toUpperCase(),
                  style: TextStyle(
                    color: _statusColor(currentCourse.status),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.7,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInformationCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required Color iconColor,
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: const Color(0xFFEFEAF8)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: iconColor, size: 25),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF9289A5),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: TextStyle(
                    color: valueColor ?? darkPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFFB69BFF),
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required String description,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFEFEAF8)),
          ),
          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: darkPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        color: Color(0xFF9289A5),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 15, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
