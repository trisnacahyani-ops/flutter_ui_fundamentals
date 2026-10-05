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
      title: 'Tahap 6 Scrollable Content',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Tahap 6 - Profile Form',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER IDENTITAS
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.person, color: Colors.white, size: 42),
                  SizedBox(height: 12),
                  Text(
                    studentName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
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

            const SizedBox(height: 24),

            const Text(
              'Profil Mahasiswa',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              'Lengkapi data berikut. Halaman dapat di-scroll '
              'ketika konten melebihi tinggi layar.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),

            const SizedBox(height: 20),

            // FORM
            buildTextField(
              label: 'Nama Lengkap',
              icon: Icons.person_outline,
              initialValue: studentName,
            ),

            const SizedBox(height: 14),

            buildTextField(
              label: 'NIM',
              icon: Icons.badge_outlined,
              initialValue: studentId,
            ),

            const SizedBox(height: 14),

            buildTextField(
              label: 'Email',
              icon: Icons.email_outlined,
              hint: 'Masukkan email',
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 14),

            buildTextField(
              label: 'No. Telepon',
              icon: Icons.phone_outlined,
              hint: 'Masukkan nomor telepon',
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 14),

            buildTextField(
              label: 'Alamat',
              icon: Icons.location_on_outlined,
              hint: 'Masukkan alamat',
              maxLines: 3,
            ),

            const SizedBox(height: 14),

            buildTextField(
              label: 'Deskripsi Diri',
              icon: Icons.edit_note,
              hint: 'Ceritakan sedikit tentang diri Anda',
              maxLines: 4,
            ),

            const SizedBox(height: 24),

            // TOMBOL
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.save),
                label: const Text(
                  'Simpan Profil',
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

            // INFORMASI
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black12),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: Colors.black),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'SingleChildScrollView digunakan agar seluruh '
                      'form tetap dapat diakses ketika tinggi konten '
                      'melebihi ukuran layar. Saat keyboard muncul, '
                      'halaman tetap dapat digulir.',
                      style: TextStyle(height: 1.4),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required IconData icon,
    String? hint,
    String? initialValue,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
      ),
    );
  }
}
