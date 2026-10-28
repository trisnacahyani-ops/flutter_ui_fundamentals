import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/course.dart';

class CourseApiService {
  CourseApiService({String? baseUrl})
    : baseUrl = baseUrl ?? 'https://course-api-pearl.vercel.app';

  final String baseUrl;

  Future<List<Course>> getCourses() async {
    final url = Uri.parse('$baseUrl/courses');

    final response = await http.get(
      url,
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mengambil data course. '
        'HTTP ${response.statusCode}: ${response.body}',
      );
    }

    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;

    return data.map((item) {
      return Course.fromJson(item as Map<String, dynamic>);
    }).toList();
  }

  Future<Course> createCourse(Course course) async {
    final url = Uri.parse('$baseUrl/courses');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(course.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final dynamic decoded = jsonDecode(response.body);

      // API dapat mengembalikan objek course secara langsung.
      if (decoded is Map<String, dynamic>) {
        return Course.fromJson(decoded);
      }

      // Jika respons bukan objek course, ambil ulang daftar course.
      final courses = await getCourses();
      final match = courses.where((item) => item.code == course.code);

      if (match.isNotEmpty) {
        return match.first;
      }

      return course;
    }

    throw Exception(
      'Gagal membuat course. '
      'HTTP ${response.statusCode}: ${response.body}',
    );
  }
}
