import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  CourseProvider(this._repository);

  final CourseRepository _repository;

  List<Course> _courses = [];
  final Set<String> _favoriteCodes = {};

  bool _isLoading = false;
  String? _error;

  // State data course
  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // State daftar favorit
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

  // Memuat data dari repository
  Future<void> loadCourses() async {
    if (_isLoading) return;

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
}
