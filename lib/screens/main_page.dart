import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import '../widgets/error_view.dart';
import 'add_course_page.dart';
import 'detail_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Tambah course',
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddCoursePage()),
              );
            },
          ),
          IconButton(
            tooltip: 'Muat ulang',
            icon: const Icon(Icons.refresh),
            onPressed: provider.isLoading ? null : provider.loadCourses,
          ),
        ],
      ),
      body: Column(
        children: [
          const Card(
            margin: EdgeInsets.all(12),
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text('Ni Komang Trisna Cahyani'),
              subtitle: Text('NIM: 2415051072'),
            ),
          ),
          Expanded(child: _buildContent(context, provider)),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, CourseProvider provider) {
    if (provider.isLoading && provider.courses.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null && provider.courses.isEmpty) {
      return ErrorView(message: provider.error!, onRetry: provider.loadCourses);
    }

    if (provider.courses.isEmpty) {
      return const Center(child: Text('Data course belum tersedia'));
    }

    return RefreshIndicator(
      onRefresh: provider.loadCourses,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: provider.courses.length,
        itemBuilder: (context, index) {
          final Course course = provider.courses[index];

          return CourseCard(
            course: course,
            isFavorite: provider.isFavorite(course.code),
            onFavoritePressed: () {
              provider.toggleFavorite(course.code);
            },
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DetailPage(course: course)),
              );
            },
          );
        },
      ),
    );
  }
}
