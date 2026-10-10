import 'package:flutter/foundation.dart';

import 'models/course.dart';
import 'repositories/course_repository.dart';

class CourseState extends ChangeNotifier {
  final CourseRepository repository;

  CourseState(this.repository);

  List<Course> courses = [];
  final Set<String> favorites = {};

  bool isLoading = false;
  String? errorMessage;

  Future<void> loadCourses() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      courses = await repository.getCourses();
    } catch (e) {
      errorMessage = 'Gagal memuat data course: $e';
    }

    isLoading = false;
    notifyListeners();
  }

  void toggleFavorite(String id) {
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }

    notifyListeners();
  }

  bool isFavorite(String id) {
    return favorites.contains(id);
  }
}
