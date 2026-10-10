import 'package:flutter/material.dart';

class StudentIdentityCard extends StatelessWidget {
  final String name;
  final String id;

  const StudentIdentityCard({super.key, required this.name, required this.id});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Identitas Mahasiswa',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Nama: $name'),
            Text('NIM: $id'),
          ],
        ),
      ),
    );
  }
}
