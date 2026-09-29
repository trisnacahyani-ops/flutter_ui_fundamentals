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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Foto profil
                    const CircleAvatar(
                      radius: 46,
                      backgroundImage: AssetImage('assets/image/trisna.jpeg'),
                    ),

                    const SizedBox(height: 12),

                    // Nama
                    const Text(
                      studentName,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // NIM
                    const Text(studentId, style: TextStyle(fontSize: 18)),

                    const SizedBox(height: 8),

                    // Skill
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.phone_android, size: 24),
                        SizedBox(width: 8),
                        Text('Mobile Programming Student'),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Deskripsi
                    const Text(
                      'Saya tertarik mempelajari pemrograman mobile '
                      'dan membuat aplikasi yang bermanfaat.',
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    // Ringkasan statistik
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.deepPurple),
                      ),
                      child: const Column(
                        children: [
                          Text(
                            'Ringkasan Pembelajaran',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 12),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '8',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('Widget'),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    '4',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('Layout'),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    '1',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('State'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Ringkasan tahap
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Tahap 7: Spacing, Container, Card, dan Styling',
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
