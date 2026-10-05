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
      title: 'Tahap 8 Passing Data',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      home: const CourseListPage(),
    );
  }
}

// =====================================================
// DATA COURSE
// =====================================================

const List<Map<String, dynamic>> courses = [
  {
    'title': 'Flutter Dasar',
    'code': 'FL001',
    'credits': 3,
    'status': 'Aktif',
    'description':
        'Mempelajari dasar pengembangan aplikasi mobile menggunakan Flutter.',
  },
  {
    'title': 'Pemrograman Dart',
    'code': 'DR002',
    'credits': 3,
    'status': 'Aktif',
    'description':
        'Mempelajari konsep dasar pemrograman menggunakan bahasa Dart.',
  },
  {
    'title': 'UI/UX Design',
    'code': 'UI003',
    'credits': 2,
    'status': 'Aktif',
    'description':
        'Mempelajari prinsip desain antarmuka dan pengalaman pengguna.',
  },
  {
    'title': 'Basis Data',
    'code': 'BD004',
    'credits': 3,
    'status': 'Selesai',
    'description':
        'Mempelajari konsep basis data, tabel, relasi, dan pengelolaannya.',
  },
  {
    'title': 'Jaringan Komputer',
    'code': 'JK005',
    'credits': 3,
    'status': 'Aktif',
    'description':
        'Mempelajari konsep dasar jaringan komputer dan komunikasi data.',
  },
  {
    'title': 'Rekayasa Perangkat Lunak',
    'code': 'RPL006',
    'credits': 3,
    'status': 'Aktif',
    'description':
        'Mempelajari proses pengembangan perangkat lunak secara sistematis.',
  },
];

// =====================================================
// COURSE LIST PAGE
// =====================================================

class CourseListPage extends StatelessWidget {
  const CourseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Tahap 8 - Course List',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Column(
        children: [
          // HEADER IDENTITAS
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.black,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  studentName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'NIM: $studentId',
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
              ],
            ),
          ),

          // JUDUL
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Daftar Course',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Pilih course untuk melihat detail.',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // LIST COURSE
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];

                return CourseCard(course: course);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// COURSE CARD
// =====================================================

class CourseCard extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),

        leading: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.school, color: Colors.white),
        ),

        title: Text(
          course['title'],
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            '${course['code']} • ${course['credits']} SKS • ${course['status']}',
            style: const TextStyle(color: Colors.grey),
          ),
        ),

        trailing: const Icon(Icons.arrow_forward_ios, size: 18),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CourseDetailPage(course: course)),
          );
        },
      ),
    );
  }
}

// =====================================================
// COURSE DETAIL PAGE
// =====================================================

class CourseDetailPage extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text(
          'Course Detail',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // COURSE HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.menu_book_rounded,
                    color: Colors.white,
                    size: 45,
                  ),

                  const SizedBox(height: 16),

                  Text(
                    course['title'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    course['code'],
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Informasi Course',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 14),

            buildInfoCard(
              icon: Icons.code,
              title: 'Kode Course',
              value: course['code'],
            ),

            const SizedBox(height: 12),

            buildInfoCard(
              icon: Icons.school_outlined,
              title: 'SKS',
              value: '${course['credits']} SKS',
            ),

            const SizedBox(height: 12),

            buildInfoCard(
              icon: Icons.check_circle_outline,
              title: 'Status',
              value: course['status'],
            ),

            const SizedBox(height: 24),

            const Text(
              'Deskripsi',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black12),
              ),
              child: Text(
                course['description'],
                style: const TextStyle(height: 1.5, fontSize: 15),
              ),
            ),

            const SizedBox(height: 24),

            // DATA MAHASISWA
            const Text(
              'Data Mahasiswa',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            buildInfoCard(
              icon: Icons.person_outline,
              title: 'Nama',
              value: studentName,
            ),

            const SizedBox(height: 12),

            buildInfoCard(
              icon: Icons.badge_outlined,
              title: 'NIM',
              value: studentId,
            ),

            const SizedBox(height: 28),

            // TOMBOL KEMBALI
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text(
                  'Kembali ke Daftar Course',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  static Widget buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
