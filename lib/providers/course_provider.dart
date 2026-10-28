import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  CourseProvider(this._repository);

  final CourseRepository _repository;

  List<Course> _courses = [];
  final Set<String> _favoriteCodes = {};

  bool _isLoading = false;
  bool _isSaving = false;
  String? _error;

  // State data course
  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // State penyimpanan course
  bool get isSaving => _isSaving;

  // State favorite
  List<Course> get favoriteCourses =>
      _courses.where((course) => _favoriteCodes.contains(course.code)).toList();

  List<Course> get favorites => favoriteCourses;

  bool isFavorite(String code) {
    return _favoriteCodes.contains(code);
  }

  void toggleFavorite(String code) {
    if (_favoriteCodes.contains(code)) {
      _favoriteCodes.remove(code);
    } else {
      _favoriteCodes.add(code);
    }

    notifyListeners();
  }

  // Mengambil data course melalui repository
  Future<void> loadCourses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _courses = await _repository.getCourses();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Membuat course melalui repository
  Future<Course> createCourse(Course course) async {
    if (_isSaving) {
      throw Exception('Penyimpanan course sedang berlangsung.');
    }

    _isSaving = true;
    notifyListeners();

    try {
      final createdCourse = await _repository.createCourse(course);

      // Muat ulang daftar dari server setelah POST berhasil.
      await loadCourses();

      // Jangan menyatakan berhasil jika proses refresh gagal.
      if (_error != null) {
        throw Exception(
          'Course terkirim, tetapi daftar gagal dimuat ulang: $_error',
        );
      }

      return createdCourse;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
