import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';

class CourseFormPage extends StatefulWidget {
  final Course?
  course; // Jika null = Tambah (Create), jika ada objek = Edit (Update)

  const CourseFormPage({super.key, this.course});

  @override
  State<CourseFormPage> createState() => _CourseFormPageState();
}

class _CourseFormPageState extends State<CourseFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codeController;
  late TextEditingController _titleController;
  late TextEditingController _creditsController;
  String _status = 'planned';

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data lama jika dalam mode edit
    _codeController = TextEditingController(text: widget.course?.code ?? '');
    _titleController = TextEditingController(text: widget.course?.title ?? '');
    _creditsController = TextEditingController(
      text: widget.course?.credits.toString() ?? '',
    );
    _status = widget.course?.status ?? 'planned';
  }

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    _creditsController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<CourseProvider>();
    final credits = int.tryParse(_creditsController.text) ?? 0;

    final courseToSave = Course(
      id: widget.course?.id,
      code: _codeController.text,
      title: _titleController.text,
      credits: credits,
      status: _status,
    );

    try {
      if (widget.course == null) {
        // Logika Create (jika dipakai untuk tambah)
        // await provider.createCourse(courseToSave);
      } else {
        // Logika Update (Tahap 7)
        await provider.updateCourse(widget.course!.id!, courseToSave);
      }

      // Validasi async gap menggunakan context.mounted
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Course berhasil diperbarui!')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.course != null;
    final provider = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Course' : 'Tambah Course')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Identitas Mahasiswa wajib tampil sesuai aturan praktikum
              const Text(
                'Ni Komang Trisna Cahyani • 2415051072',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),

              // Code field (Read-only saat edit agar konsisten dengan relasi favorites)
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Kode Course',
                  border: OutlineInputBorder(),
                ),
                readOnly: isEditing,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Kode wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              // Title field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul Course',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Judul wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              // Credits field
              TextFormField(
                controller: _creditsController,
                decoration: const InputDecoration(
                  labelText: 'Jumlah SKS',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || int.tryParse(value) == null) {
                    return 'Masukkan angka SKS yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Status Dropdown
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: 'Status Course',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'planned', child: Text('Planned')),
                  DropdownMenuItem(value: 'active', child: Text('Active')),
                  DropdownMenuItem(value: 'done', child: Text('Done')),
                ],
                onChanged: (val) => setState(() => _status = val ?? 'planned'),
              ),
              const SizedBox(height: 24),

              // Tombol Simpan dengan penonaktifan otomatis (isSaving) untuk mencegah double-submit
              ElevatedButton(
                onPressed: provider.isSaving ? null : _saveForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: provider.isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        isEditing ? 'Simpan Perubahan' : 'Tambah Course',
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
