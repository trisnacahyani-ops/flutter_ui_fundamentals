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

    // Menghitung jumlah topik yang sudah selesai
    final int completed = topics.where((item) => item['done'] == true).length;

    return Column(
      children: [
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
              const SizedBox(height: 10),

              // Ringkasan data collection
              Text(
                '$completed dari ${topics.length} topik selesai',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const Divider(),

        // Menampilkan list dengan separator
        Expanded(
          child: ListView.separated(
            itemCount: topics.length,
            separatorBuilder: (context, index) => const SizedBox(height: 2),
            itemBuilder: (context, index) {
              final item = topics[index];
              final bool isDone = item['done'] == true;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: Icon(
                    isDone ? Icons.check_circle : Icons.schedule,
                    color: isDone ? Colors.green : Colors.orange,
                  ),
                  title: Text(
                    item['title'] as String,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(item['subtitle'] as String),
                  trailing: Text(
                    isDone ? 'Selesai' : 'Belum',
                    style: TextStyle(
                      color: isDone ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
