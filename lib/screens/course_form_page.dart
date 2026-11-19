import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';

class CourseFormPage extends StatefulWidget {
  final Course? course;

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

  static const Color primaryPurple = Color(0xFF7956D8);
  static const Color backgroundColor = Color(0xFFF8F7FF);

  bool _isSubmitting = false;

  bool get isEditing => widget.course != null;

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
    if (_isSubmitting) return;

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

    setState(() {
      _isSubmitting = true;
    });

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
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan course: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: primaryPurple),
      filled: true,
      fillColor: const Color(0xFFF9F7FF),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE9E2FA)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primaryPurple, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF30264A),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildStatusOption({
    required String value,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    final selected = _status == value;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: _isSubmitting
          ? null
          : () {
              setState(() {
                _status = value;
              });
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.09) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? color : const Color(0xFFEAE5F4),
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.13),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? color : Colors.black26,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final isSaving = _isSubmitting || provider.isSaving;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Course' : 'Tambah Course',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF30264A),
          ),
        ),
        backgroundColor: backgroundColor,
        foregroundColor: primaryPurple,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF7956D8),
                          Color(0xFFB18AF5),
                          Color(0xFFE7B5E8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: primaryPurple.withValues(alpha: 0.18),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isEditing ? 'Perbarui Course' : 'Course Baru',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 9),
                              Text(
                                isEditing
                                    ? 'Ubah informasi course sesuai kebutuhanmu.'
                                    : 'Tambahkan course ke daftar pembelajaranmu.',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 13,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            isEditing
                                ? Icons.edit_note_rounded
                                : Icons.library_add_rounded,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 7),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle(
                            'Informasi Course',
                            'Lengkapi informasi course yang ingin disimpan.',
                          ),

                          const SizedBox(height: 22),

                          TextFormField(
                            controller: _codeController,
                            readOnly: isEditing,
                            decoration: _inputDecoration(
                              label: 'Kode Course',
                              hint: 'Contoh: MOB01',
                              icon: Icons.code_rounded,
                            ),
                            textCapitalization: TextCapitalization.characters,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Kode course wajib diisi.';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 18),

                          TextFormField(
                            controller: _titleController,
                            decoration: _inputDecoration(
                              label: 'Judul Course',
                              hint: 'Contoh: Pemrograman Mobile',
                              icon: Icons.menu_book_rounded,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Judul course wajib diisi.';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 18),

                          TextFormField(
                            controller: _creditsController,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration(
                              label: 'Jumlah SKS',
                              hint: 'Contoh: 2',
                              icon: Icons.numbers_rounded,
                            ),
                            validator: (value) {
                              final credits = int.tryParse(value?.trim() ?? '');

                              if (credits == null || credits <= 0) {
                                return 'Masukkan jumlah SKS yang valid.';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 25),

                          _buildSectionTitle(
                            'Status Course',
                            'Pilih status course saat ini.',
                          ),

                          const SizedBox(height: 14),

                          _buildStatusOption(
                            value: 'planned',
                            title: 'Planned',
                            description: 'Course belum dimulai',
                            icon: Icons.event_note_rounded,
                            color: Colors.orange,
                          ),

                          const SizedBox(height: 10),

                          _buildStatusOption(
                            value: 'active',
                            title: 'Active',
                            description: 'Course sedang berjalan',
                            icon: Icons.play_circle_outline_rounded,
                            color: Colors.green,
                          ),

                          const SizedBox(height: 10),

                          _buildStatusOption(
                            value: 'done',
                            title: 'Done',
                            description: 'Course telah diselesaikan',
                            icon: Icons.check_circle_outline_rounded,
                            color: Colors.blue,
                          ),

                          const SizedBox(height: 28),

                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton.icon(
                              onPressed: isSaving ? null : _saveForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryPurple,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: primaryPurple
                                    .withValues(alpha: 0.5),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              icon: isSaving
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Icon(
                                      isEditing
                                          ? Icons.save_rounded
                                          : Icons.add_rounded,
                                    ),
                              label: Text(
                                isSaving
                                    ? 'Menyimpan...'
                                    : isEditing
                                    ? 'Simpan Perubahan'
                                    : 'Tambah Course',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Center(
                    child: Text(
                      'Course Explorer • Manage Your Learning',
                      style: TextStyle(fontSize: 11, color: Colors.black38),
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
