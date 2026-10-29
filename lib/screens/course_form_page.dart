import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';

class CourseFormPage extends StatefulWidget {
  final Course? course;

  // course null = tambah, course berisi data = edit.
  const CourseFormPage({super.key, this.course});

  @override
  State<CourseFormPage> createState() => _CourseFormPageState();
}

class _CourseFormPageState extends State<CourseFormPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _codeController;
  late final TextEditingController _titleController;
  late final TextEditingController _creditsController;

  String _status = 'planned';

  @override
  void initState() {
    super.initState();

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
    final credits = int.tryParse(_creditsController.text.trim());

    if (credits == null || credits <= 0) return;

    final courseToSave = Course(
      id: widget.course?.id,
      code: _codeController.text.trim(),
      title: _titleController.text.trim(),
      credits: credits,
      status: _status,
    );

    final isEditing = widget.course != null;

    try {
      if (isEditing) {
        final courseId = widget.course!.id;

        if (courseId == null) {
          throw Exception('ID course tidak ditemukan.');
        }

        await provider.updateCourse(courseId, courseToSave);
      } else {
        await provider.createCourse(courseToSave);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing
                ? 'Course berhasil diperbarui!'
                : 'Course berhasil ditambahkan!',
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal menyimpan course: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.course != null;
    final provider = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Course' : 'Tambah Course')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const Card(
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Ni Komang Trisna Cahyani'),
                      subtitle: Text('NIM: 2415051072'),
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _codeController,
                    readOnly: isEditing,
                    decoration: const InputDecoration(
                      labelText: 'Kode Course',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Kode wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Judul Course',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Judul wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _creditsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Jumlah SKS',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      final credits = int.tryParse(value?.trim() ?? '');

                      if (credits == null || credits <= 0) {
                        return 'Masukkan jumlah SKS yang valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    initialValue: _status,
                    decoration: const InputDecoration(
                      labelText: 'Status Course',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'planned',
                        child: Text('Planned'),
                      ),
                      DropdownMenuItem(value: 'active', child: Text('Active')),
                      DropdownMenuItem(value: 'done', child: Text('Done')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _status = value ?? 'planned';
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  ElevatedButton.icon(
                    onPressed: provider.isSaving ? null : _saveForm,
                    icon: provider.isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(isEditing ? Icons.save : Icons.add),
                    label: Text(
                      provider.isSaving
                          ? 'Menyimpan...'
                          : isEditing
                          ? 'Simpan Perubahan'
                          : 'Tambah Course',
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
