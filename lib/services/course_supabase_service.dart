import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/course.dart';
import 'course_data_source.dart';

class CourseSupabaseService implements CourseDataSource {
  final SupabaseClient _client = Supabase.instance.client;
  final String _tableName = 'courses';

  @override
  Future<List<Course>> getCourses() async {
    final response = await _client.from(_tableName).select();
    final List<dynamic> data = response as List<dynamic>;
    return data
        .map((item) => Course.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Course> createCourse(Course course) async {
    final response = await _client
        .from(_tableName)
        .insert(course.toJson())
        .select()
        .single();
    return Course.fromJson(response);
  }

  @override
  Future<void> updateCourse(int id, Course course) async {
    await _client.from(_tableName).update(course.toJson()).eq('id', id);
  }

  @override
  Future<void> deleteCourse(int id) async {
    await _client.from(_tableName).delete().eq('id', id);
  }
}
