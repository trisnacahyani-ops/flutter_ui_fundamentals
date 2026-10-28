import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/course.dart';

class CourseApiService {
  CourseApiService({this.baseUrl = 'https://course-api-pearl.vercel.app'});

  final String baseUrl;

  Future<List<Course>> getCourses() async {
    final url = Uri.parse('$baseUrl/courses');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mengambil data course. '
        'HTTP ${response.statusCode}',
      );
    }

    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;

    return data.map((item) {
      return Course.fromJson(item as Map<String, dynamic>);
    }).toList();
  }
}
