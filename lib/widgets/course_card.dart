import 'package:flutter/material.dart';

import '../models/course.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;

  const CourseCard({
    super.key,
    required this.course,
    required this.isFavorite,
    required this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.black,
          child: Icon(Icons.school, color: Colors.white),
        ),
        title: Text(
          course.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Kode: ${course.code}\n'
          'SKS: ${course.credits}\n'
          'Status: ${course.status}',
        ),
        isThreeLine: true,
        trailing: IconButton(
          onPressed: onFavoritePressed,
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.black,
          ),
        ),
      ),
    );
  }
}
