import 'package:flutter/material.dart';

void main() {
  runApp(const CourseExplorerApp());
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer - Tahap 1',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Local State 1: Indeks tab aktif BottomNavigationBar
  int _currentIndex = 0;

  final List<Widget> _pages = const [HomePage(), CoursesPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer v2 - Tahap 1'),
        backgroundColor: Colors.blue.shade100,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          // Local State: Mengubah tab aktif
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Courses'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Local State 2: Visibilitas detail kartu
  bool _showDetail = false;

  // Local State 3: Status Tombol Like
  bool _isLiked = false;
  int _likeCount = 0;

  // Identitas Mahasiswa
  final String studentName = 'Ni Komang Trisna Cahyani';
  final String studentId = '2415051072';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner Tahap 1
          Card(
            color: Colors.black,
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Icon(Icons.mobile_friendly, color: Colors.white, size: 40),
                  SizedBox(height: 8),
                  Text(
                    'Course Explorer v2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Tahap 1 - Local State & Shared State',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Card Identitas Mahasiswa
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Identitas Mahasiswa',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.black12,
                        child: Icon(Icons.person, color: Colors.black),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Nama',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                          Text(
                            studentName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.black12,
                        child: Icon(Icons.badge, color: Colors.black),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'NIM',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                          Text(
                            studentId,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Demo Local State (Expand Detail + Tombol Like)
          Card(
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.book, color: Colors.blue),
                    title: const Text(
                      'State Management Architecture',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text('Contoh penggunaan setState()'),
                    trailing: IconButton(
                      icon: Icon(
                        _showDetail
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                      ),
                      onPressed: () {
                        // Toggle detail
                        setState(() {
                          _showDetail = !_showDetail;
                        });
                      },
                    ),
                  ),

                  // Tombol Like (Fitur Baru)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                _isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: _isLiked ? Colors.red : Colors.grey,
                              ),
                              onPressed: () {
                                // Local State: Mengubah status Like
                                setState(() {
                                  _isLiked = !_isLiked;
                                  if (_isLiked) {
                                    _likeCount++;
                                  } else {
                                    _likeCount--;
                                  }
                                });
                              },
                            ),
                            Text('$_likeCount Likes'),
                          ],
                        ),
                        Text(
                          _isLiked ? 'Disukai' : 'Belum disukai',
                          style: TextStyle(
                            color: _isLiked ? Colors.red : Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (_showDetail) ...[
                    const Divider(),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Ini adalah contoh Local State. Baik visibilitas detail maupun status tombol Like dikelola secara mandiri di dalam widget ini menggunakan setState().',
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Halaman Daftar Kursus'));
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Halaman Profil Mahasiswa'));
  }
}
