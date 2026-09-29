import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MyApp());
}

// Membaca data dari file JSON
Future<Map<String, dynamic>> loadStudentData() async {
  final jsonString = await rootBundle.loadString(
    'assets/data/student_data.json',
  );

  return jsonDecode(jsonString) as Map<String, dynamic>;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Learning Dashboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DashboardPage(),
    );
  }
}

// Dashboard utama
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<Map<String, dynamic>> studentFuture;

  @override
  void initState() {
    super.initState();

    studentFuture = loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Dashboard'),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: studentFuture,
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error state
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Gagal memuat data:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          // Data tidak tersedia
          if (!snapshot.hasData) {
            return const Center(child: Text('Data tidak tersedia'));
          }

          final data = snapshot.data!;

          final student = data['student'] as Map<String, dynamic>;

          final courses = data['courses'] as List<dynamic>;

          final int totalCourses = courses.length;

          final int totalCredits = courses.fold(
            0,
            (sum, item) => sum + (item['credits'] as int),
          );

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Card
                  buildProfileCard(student: student),

                  const SizedBox(height: 16),

                  // Judul summary
                  const Text(
                    'Ringkasan Pembelajaran',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  // Summary Cards
                  Row(
                    children: [
                      Expanded(
                        child: buildSummaryCard(
                          icon: Icons.menu_book,
                          value: '$totalCourses',
                          label: 'Mata Kuliah',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: buildSummaryCard(
                          icon: Icons.school,
                          value: '$totalCredits',
                          label: 'Total SKS',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Judul courses
                  const Text(
                    'Daftar Pembelajaran',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  // List courses
                  ...courses.map(
                    (item) => buildCourseCard(item as Map<String, dynamic>),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Reusable widget untuk profile
Widget buildProfileCard({required Map<String, dynamic> student}) {
  return Card(
    elevation: 3,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 42,
            backgroundImage: AssetImage('assets/image/trisna.jpeg'),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student['name'] as String,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'NIM: ${student['nim']}',
                  style: const TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 4),

                Text(
                  'Semester: ${student['semester']}',
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// Reusable widget untuk summary
Widget buildSummaryCard({
  required IconData icon,
  required String value,
  required String label,
}) {
  return Card(
    elevation: 2,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(icon, size: 32),

          const SizedBox(height: 8),

          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 4),

          Text(label, textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}

// Reusable widget untuk course
Widget buildCourseCard(Map<String, dynamic> course) {
  final String status = course['status'] as String;

  final bool isDone = status == 'done';
  final bool isActive = status == 'active';

  IconData icon;

  if (isDone) {
    icon = Icons.check_circle;
  } else if (isActive) {
    icon = Icons.play_circle;
  } else {
    icon = Icons.schedule;
  }

  String statusText;

  if (isDone) {
    statusText = 'Selesai';
  } else if (isActive) {
    statusText = 'Aktif';
  } else {
    statusText = 'Belum';
  }

  return Card(
    margin: const EdgeInsets.only(bottom: 10),
    child: ListTile(
      leading: Icon(icon, size: 32),

      title: Text(
        course['title'] as String,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),

      subtitle: Text('${course['code']} • ${course['credits']} SKS'),

      trailing: Text(
        statusText,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
  );
}
