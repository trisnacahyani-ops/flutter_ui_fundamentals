import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import '../widgets/error_view.dart';
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
    // 1. Loading state
    if (provider.isLoading && provider.courses.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // 2. Error state
    if (provider.error != null && provider.courses.isEmpty) {
      return ErrorView(message: provider.error!, onRetry: provider.loadCourses);
    }

    // 3. Empty state
    if (provider.courses.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 56),
            SizedBox(height: 12),
            Text('Data course belum tersedia'),
          ],
        ),
      );
    }

    // 4. Success state
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
