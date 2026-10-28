import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider with ChangeNotifier {
  CourseProvider(this.repository);
  final CourseRepository repository;

  List<Course> _courses = [];
  final Set<String> _favoriteCodes = {};

  bool _isLoading = false;
  bool _isSaving = false;
  String? _error;

  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;

  List<Course> get favoriteCourses {
    return _courses
        .where((course) => _favoriteCodes.contains(course.code))
        .toList();
  }

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

  Future<void> loadCourses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _courses = await repository.getCourses();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createCourse(Course course) async {
    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      await repository.createCourse(course);
      await loadCourses();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<void> updateCourse(int id, Course course) async {
    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      await repository.updateCourse(id, course);
      await loadCourses();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
