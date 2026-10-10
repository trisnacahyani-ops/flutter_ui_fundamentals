import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import '../widgets/student_identity_card.dart';
import 'detail_page.dart';
import 'favorites_page.dart';

const String studentName = 'Ni Komang Trisna Cahyani';
const String studentId = '2415051072';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedIndex == 0 ? 'Daftar Course' : 'Course Favorite'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: selectedIndex == 0
          ? _buildCourseList(provider)
          : const FavoritesPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: Colors.black,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Courses'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }

  Widget _buildCourseList(CourseProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.black),
      );
    }

    if (provider.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text(
                'Gagal memuat course:\n${provider.error}',
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
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const StudentIdentityCard(name: studentName, id: studentId),
        const SizedBox(height: 24),
        const Text(
          'Daftar Course',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (provider.courses.isEmpty)
          const Text('Belum ada data course.')
        else
          ...provider.courses.map((course) {
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
        const SizedBox(height: 12),
        Card(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Total favorite: ${provider.favorites.length}',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
