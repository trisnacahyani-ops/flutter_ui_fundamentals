import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const StudentPage(),
    );
  }
}

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  Map<String, dynamic>? studentData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStudentData();
  }

  Future<void> loadStudentData() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/student_data.json',
    );

    final data = jsonDecode(jsonString) as Map<String, dynamic>;

    setState(() {
      studentData = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final student = studentData!['student'] as Map<String, dynamic>;

    final courses = studentData!['courses'] as List<dynamic>;

    final int completed = courses
        .where((item) => item['status'] == 'done')
        .length;

    return Scaffold(
      appBar: AppBar(title: const Text('Flutter UI Fundamentals')),
      body: Column(
        children: [
          // Identitas mahasiswa
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Text(
                  student['name'] as String,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  student['nim'] as String,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),

                // Ringkasan
                Text(
                  '$completed dari ${courses.length} topik selesai',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          // Daftar courses dari JSON
          Expanded(
            child: ListView.separated(
              itemCount: courses.length,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 2);
              },
              itemBuilder: (context, index) {
                final item = courses[index] as Map<String, dynamic>;

                final String status = item['status'] as String;

                final bool isDone = status == 'done';

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: Icon(
                      isDone
                          ? Icons.check_circle
                          : status == 'active'
                          ? Icons.play_circle
                          : Icons.schedule,
                      color: isDone
                          ? Colors.green
                          : status == 'active'
                          ? Colors.blue
                          : Colors.orange,
                    ),
                    title: Text(
                      item['title'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${item['code']} • ${item['credits']} SKS'),
                    trailing: Text(
                      isDone
                          ? 'Selesai'
                          : status == 'active'
                          ? 'Aktif'
                          : 'Belum',
                      style: TextStyle(
                        color: isDone
                            ? Colors.green
                            : status == 'active'
                            ? Colors.blue
                            : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Keterangan tahap
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Tahap 12 - Membaca Data dari JSON',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
