import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import '../widgets/student_identity_card.dart';
import 'detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  static const Color primaryPurple = Color(0xFF7956D8);
  static const Color backgroundColor = Color(0xFFF8F7FF);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final favoriteCourses = provider.favoriteCourses;

    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: primaryPurple),
      );
    }

    if (provider.error != null) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cloud_off_rounded,
                color: Colors.redAccent,
                size: 48,
              ),
              const SizedBox(height: 14),
              const Text(
                'Gagal Memuat Favorite',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                provider.error.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      color: backgroundColor,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const StudentIdentityCard(
            name: 'Ni Komang Trisna Cahyani',
            id: '2415051072',
          ),

          const SizedBox(height: 24),

          // Header Favorite
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF7956D8),
                  Color(0xFFB18AF5),
                  Color(0xFFE7B5E8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: primaryPurple.withValues(alpha: 0.16),
                  blurRadius: 18,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'My Favorites',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Kumpulan course pilihan yang kamu sukai.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(19),
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: Colors.white,
                    size: 34,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Statistik Favorite
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withValues(alpha: 0.04),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE8F0),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: Color(0xFFE85D8E),
                    size: 25,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Course Favorite',
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${favoriteCourses.length} Course',
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF30264A),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // Judul Daftar
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Course Favorite',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF30264A),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE5FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${favoriteCourses.length} Item',
                  style: const TextStyle(
                    color: primaryPurple,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Kondisi Favorite Kosong
          if (favoriteCourses.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 35),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withValues(alpha: 0.04),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.favorite_border_rounded,
                    size: 65,
                    color: Color(0xFFD3C6ED),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Belum Ada Course Favorite',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF30264A),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Kamu belum memiliki course favorit.\n'
                    'Tambahkan course melalui halaman Courses '
                    'dengan menekan ikon hati.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            ...favoriteCourses.map((course) {
              return CourseCard(
                course: course,
                isFavorite: provider.isFavorite(course.code),
                onFavoritePressed: () {
                  context.read<CourseProvider>().toggleFavorite(course.code);
                },
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailPage(course: course),
                    ),
                  );
                },
              );
            }),

          const SizedBox(height: 20),

          const Center(
            child: Text(
              'Course Explorer • Your Favorite Learning',
              style: TextStyle(fontSize: 11, color: Colors.black38),
            ),
          ),
        ],
      ),
    );
  }
}
