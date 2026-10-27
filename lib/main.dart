import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String apiUrl = 'https://course-api-pearl.vercel.app/courses';

Future<List<dynamic>> fetchCourses() async {
  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    return jsonDecode(response.body) as List<dynamic>;
  }

  throw Exception('HTTP ${response.statusCode}');
}

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HttpGetTestPage(),
    ),
  );
}

class HttpGetTestPage extends StatefulWidget {
  const HttpGetTestPage({super.key});

  @override
  State<HttpGetTestPage> createState() => _HttpGetTestPageState();
}

class _HttpGetTestPageState extends State<HttpGetTestPage> {
  String result = 'Mengambil data mata kuliah...';

  @override
  void initState() {
    super.initState();
    loadCourses();
  }

  Future<void> loadCourses() async {
    try {
      final courses = await fetchCourses();

      debugPrint('Jumlah data mata kuliah: ${courses.length}');

      if (!mounted) return;
      setState(() {
        result =
            'Berhasil mengambil data.\n'
            'Jumlah mata kuliah: ${courses.length}';
      });
    } catch (error) {
      debugPrint('Gagal mengambil data: $error');

      if (!mounted) return;
      setState(() {
        result = 'Gagal mengambil data.\n$error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengujian HTTP GET')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Identitas Mahasiswa',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Nama: Ni Komang Trisna Cahyani'),
              const Text('NIM: 2415051072'),
              const SizedBox(height: 24),
              const Icon(Icons.cloud_download, size: 48),
              const SizedBox(height: 12),
              Text(result, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: loadCourses,
                child: const Text('Ambil Data Lagi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
