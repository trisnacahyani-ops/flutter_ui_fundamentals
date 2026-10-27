import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/course.dart';

const String apiUrl = 'https://course-api-pearl.vercel.app/courses';

Future<List<Course>> fetchCourses() async {
  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;

    return data
        .map((item) => Course.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  throw Exception('HTTP ${response.statusCode}');
}

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CourseModelTestPage(),
    ),
  );
}

class CourseModelTestPage extends StatefulWidget {
  const CourseModelTestPage({super.key});

  @override
  State<CourseModelTestPage> createState() => _CourseModelTestPageState();
}

class _CourseModelTestPageState extends State<CourseModelTestPage> {
  List<Course> courses = [];
  String errorMessage = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCourses();
  }

  Future<void> loadCourses() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final result = await fetchCourses();

      if (!mounted) return;
      setState(() {
        courses = result;
        isLoading = false;
      });

      debugPrint('Jumlah data: ${courses.length}');
      for (final course in courses.take(3)) {
        debugPrint('${course.code} - ${course.title} - ${course.status}');
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        errorMessage = error.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Mata Kuliah')),
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
          if (isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (errorMessage.isNotEmpty)
            Expanded(
              child: Center(
                child: Text('Gagal mengambil data:\n$errorMessage'),
              ),
            )
          else
            Expanded(
              child: RefreshIndicator(
                onRefresh: loadCourses,
                child: ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(course.credits.toString()),
                        ),
                        title: Text('${course.code} - ${course.title}'),
                        subtitle: Text('Status: ${course.status}'),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: loadCourses,
        tooltip: 'Muat ulang data',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
