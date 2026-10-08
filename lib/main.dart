import 'package:flutter/material.dart';

const String studentName = 'Ni Komang Trisna Cahyani';
const String studentId = '2415051072';

void main() {
  runApp(const CourseExplorerApp());
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer - Tahap 3',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

// ======================================================
// PARENT
// ======================================================

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Single Source of Truth
  bool favorite = false;

  void toggleFavorite() {
    setState(() {
      favorite = !favorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 3 - Lifting State Up')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================================================
            // IDENTITAS
            // ==================================================

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Identitas Mahasiswa',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Nama: $studentName'),
                    Text('NIM: $studentId'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ==================================================
            // COURSE CARD
            // ==================================================
            const Text(
              'Course',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            CourseCard(
              courseName: 'Flutter UI Fundamentals',
              isFavorite: favorite,
              onFavoriteChanged: toggleFavorite,
            ),

            const SizedBox(height: 20),

            // ==================================================
            // WIDGET KEDUA
            // ==================================================
            FavoriteStatus(isFavorite: favorite),

            const SizedBox(height: 20),

            // ==================================================
            // SINGLE SOURCE OF TRUTH
            // ==================================================
            Card(
              color: favorite ? Colors.black : Colors.grey.shade200,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      favorite ? Icons.check_circle : Icons.info_outline,
                      color: favorite ? Colors.white : Colors.black,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        favorite
                            ? 'State favorite = TRUE'
                            : 'State favorite = FALSE',
                        style: TextStyle(
                          color: favorite ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// CHILD 1
// ======================================================

class CourseCard extends StatelessWidget {
  final String courseName;
  final bool isFavorite;
  final VoidCallback onFavoriteChanged;

  const CourseCard({
    super.key,
    required this.courseName,
    required this.isFavorite,
    required this.onFavoriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.school),
        title: Text(
          courseName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          isFavorite
              ? 'Course ditambahkan ke favorite'
              : 'Course belum menjadi favorite',
        ),
        trailing: IconButton(
          onPressed: onFavoriteChanged,
          icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
        ),
      ),
    );
  }
}

// ======================================================
// CHILD 2
// ======================================================

class FavoriteStatus extends StatelessWidget {
  final bool isFavorite;

  const FavoriteStatus({super.key, required this.isFavorite});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(isFavorite ? Icons.favorite : Icons.favorite_border, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isFavorite
                    ? 'Favorite Status: AKTIF'
                    : 'Favorite Status: TIDAK AKTIF',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
