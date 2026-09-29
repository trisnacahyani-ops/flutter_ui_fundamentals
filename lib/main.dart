import 'package:flutter/material.dart';

const String studentName = 'Ni Komang Trisna Cahyani';
const String studentId = '2415051072';

// Function widget yang dapat digunakan ulang
Widget buildStatCard(String value, String label, IconData icon) {
  return Expanded(
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(label),
          ],
        ),
      ),
    ),
  );
}

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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 46,
                      backgroundImage: AssetImage('assets/image/trisna.jpeg'),
                    ),
                    const SizedBox(height: 12),

                    // Identitas mahasiswa
                    const Text(
                      studentName,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(studentId, style: TextStyle(fontSize: 18)),

                    const SizedBox(height: 8),

                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.phone_android, size: 24),
                        SizedBox(width: 8),
                        Text('Mobile Programming Student'),
                      ],
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Saya tertarik mempelajari pemrograman mobile '
                      'dan membuat aplikasi yang bermanfaat.',
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    // Statistik menggunakan function yang dapat digunakan ulang
                    const Text(
                      'Ringkasan Pembelajaran',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        buildStatCard('8', 'Widget', Icons.widgets),
                        buildStatCard('4', 'Layout', Icons.view_quilt),
                        buildStatCard('1', 'State', Icons.sync),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Tahap 8: Widget yang Dapat Digunakan Ulang',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
