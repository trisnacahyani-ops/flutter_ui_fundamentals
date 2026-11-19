import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';

class AddCoursePage extends StatefulWidget {
  const AddCoursePage({super.key});

  @override
  State<AddCoursePage> createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  final _formKey = GlobalKey<FormState>();

  final _codeController = TextEditingController();
  final _titleController = TextEditingController();
  final _creditsController = TextEditingController();

  String _status = 'planned';
  bool _isSubmitting = false;

  static const Color primaryPurple = Color(0xFF7956D8);
  static const Color backgroundColor = Color(0xFFF8F7FF);

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    _creditsController.dispose();
    super.dispose();
  }

  Future<void> _saveCourse() async {
    if (_isSubmitting) return;

    if (!_formKey.currentState!.validate()) return;

    final code = _codeController.text.trim();
    final title = _titleController.text.trim();
    final credits = int.tryParse(_creditsController.text.trim());

    if (credits == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jumlah SKS harus berupa angka.')),
      );
      return;
    }

    final provider = context.read<CourseProvider>();

    setState(() {
      _isSubmitting = true;
    });

    try {
      final course = Course(
        code: code,
        title: title,
        credits: credits,
        status: _status,
      );

      await provider.createCourse(course);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Course berhasil ditambahkan.'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menambahkan course: $e'),
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
        title: const Text(
          'Tambah Course',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF30264A),
          ),
        ),
        backgroundColor: backgroundColor,
        foregroundColor: primaryPurple,
        elevation: 0,
        centerTitle: false,
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
                              const Text(
                                'Course Baru',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 9),
                              Text(
                                'Tambahkan course ke daftar pembelajaranmu.',
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
                          child: const Icon(
                            Icons.library_add_rounded,
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
                            'Lengkapi informasi course yang ingin ditambahkan.',
                          ),

                          const SizedBox(height: 22),

                          TextFormField(
                            controller: _codeController,
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
                            decoration: _inputDecoration(
                              label: 'Jumlah SKS',
                              hint: 'Contoh: 2',
                              icon: Icons.numbers_rounded,
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Jumlah SKS wajib diisi.';
                              }

                              final credits = int.tryParse(value.trim());

                              if (credits == null || credits <= 0) {
                                return 'Masukkan angka SKS yang valid.';
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
                              onPressed: isSaving ? null : _saveCourse,
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
                                  : const Icon(Icons.save_rounded),
                              label: Text(
                                isSaving ? 'Menyimpan...' : 'Simpan Course',
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
