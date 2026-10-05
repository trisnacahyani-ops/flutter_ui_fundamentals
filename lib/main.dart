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
      title: 'Tahap 1 Responsive Layout',
<<<<<<< HEAD
      theme: ThemeData(primarySwatch: Colors.black),
=======
      theme: ThemeData(primarySwatch: Colors.blue),
>>>>>>> 9991e03 (tahap 1)
      home: const ResponsiveLayoutPage(),
    );
  }
}

class ResponsiveLayoutPage extends StatelessWidget {
  const ResponsiveLayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 1 - Responsive Layout')),
      body: Center(
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(16),
          child: Text(
            '$studentId - $studentName',
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
