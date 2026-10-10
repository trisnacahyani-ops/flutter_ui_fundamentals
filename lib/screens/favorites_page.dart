import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import '../widgets/student_identity_card.dart';
import 'detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final favoriteCourses = provider.favoriteCourses;

    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.black),
      );
    }

    if (provider.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Gagal memuat data:\n${provider.error}',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const StudentIdentityCard(
          name: 'Ni Komang Trisna Cahyani',
          id: '2415051072',
        ),
        const SizedBox(height: 24),
        Text(
          'Course Favorite (${favoriteCourses.length})',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (favoriteCourses.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(Icons.favorite_border, size: 56),
                  SizedBox(height: 12),
                  Text(
                    'Belum ada course favorite.',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tambahkan course melalui halaman Courses.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
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
                  MaterialPageRoute(builder: (_) => DetailPage(course: course)),
                );
              },
            );
          }),
      ],
    );
  }
}
