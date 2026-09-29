import 'package:flutter/material.dart';

const String studentName = 'Ni Komang Trisna Cahyani';
const String studentId = '2415051072';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter UI Fundamentals')),
        body: const TopicList(),
      ),
    );
  }
}

class TopicList extends StatelessWidget {
  const TopicList({super.key});

  @override
  Widget build(BuildContext context) {
    // Collection Dart
    final List<Map<String, dynamic>> topics = [
      {'title': 'Git & GitHub', 'subtitle': 'Version control', 'done': true},
      {
        'title': 'Dart Fundamentals',
        'subtitle': 'Language basics',
        'done': true,
      },
      {
        'title': 'Flutter UI Fundamentals',
        'subtitle': 'Widgets & layout',
        'done': false,
      },
      {
        'title': '$studentId - $studentName',
        'subtitle': 'Pemilik aplikasi',
        'done': false,
      },
    ];

    return Column(
      children: [
        // Identitas mahasiswa tetap di atas daftar
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              const Text(
                studentName,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(studentId, style: TextStyle(fontSize: 18)),
            ],
          ),
        ),

        const Divider(),

        // ListView membutuhkan Expanded
        Expanded(
          child: ListView.builder(
            itemCount: topics.length,
            itemBuilder: (context, index) {
              final item = topics[index];

              return ListTile(
                leading: Icon(
                  item['done'] == true
                      ? Icons.check_circle
                      : Icons.circle_outlined,
                ),
                title: Text(item['title'] as String),
                subtitle: Text(item['subtitle'] as String),
              );
            },
          ),
        ),
      ],
    );
  }
}
