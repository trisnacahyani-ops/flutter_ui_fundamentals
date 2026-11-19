import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';
import '../widgets/course_card.dart';
import '../widgets/error_view.dart';
import 'add_course_page.dart';
import 'detail_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  static const Color primaryPurple = Color(0xFF7956D8);
  static const Color lightPurple = Color(0xFFF2EDFF);
  static const Color backgroundColor = Color(0xFFF8F7FF);

  Future<void> _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah kamu yakin ingin keluar dari akun?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Batal'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: primaryPurple),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      await AuthService.instance.logout();
    } catch (error) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout gagal: $error'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.white,
        backgroundColor: primaryPurple,
        title: const Text(
          'Course Explorer',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.3),
        ),
        actions: [
          IconButton(
            tooltip: 'Muat ulang',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: provider.isLoading ? null : provider.loadCourses,
          ),
          IconButton(
            tooltip: 'Tambah course',
            icon: const Icon(Icons.add_circle_outline_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddCoursePage()),
              );
            },
          ),
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => _logout(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        color: primaryPurple,
        onRefresh: () async {
          await Future.wait([provider.loadCourses(), ProfileCard.reload()]);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
          children: [
            _buildWelcomeSection(),
            const SizedBox(height: 20),
            const ProfileCard(),
            const SizedBox(height: 22),
            _buildStatisticCard(provider.courses.length),
            const SizedBox(height: 26),
            _buildSectionTitle(),
            const SizedBox(height: 14),
            _buildCourseContent(context, provider),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryPurple,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Tambah Course',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddCoursePage()),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7956D8), Color(0xFF9B78F2), Color(0xFFB69BFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryPurple.withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo! 👋',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Jelajahi dan kelola daftar course-mu dengan mudah.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.school_rounded, color: Colors.white, size: 58),
        ],
      ),
    );
  }

  Widget _buildStatisticCard(int totalCourses) {
    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFE5F0), Color(0xFFFFF0F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.menu_book_rounded,
              color: Color(0xFFEC6FA5),
              size: 27,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Course',
                  style: TextStyle(color: Color(0xFF95627A), fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  '$totalCourses Course',
                  style: const TextStyle(
                    color: Color(0xFF713B58),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.auto_awesome_rounded,
            color: Color(0xFFEC6FA5),
            size: 27,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle() {
    return const Row(
      children: [
        Icon(Icons.grid_view_rounded, color: primaryPurple, size: 23),
        SizedBox(width: 9),
        Text(
          'Daftar Course',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: Color(0xFF30264A),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseContent(BuildContext context, CourseProvider provider) {
    if (provider.isLoading && provider.courses.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(35),
        child: Center(child: CircularProgressIndicator(color: primaryPurple)),
      );
    }

    if (provider.error != null && provider.courses.isEmpty) {
      return ErrorView(message: provider.error!, onRetry: provider.loadCourses);
    }

    if (provider.courses.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Column(
          children: [
            Icon(Icons.menu_book_outlined, color: Color(0xFFB69BFF), size: 55),
            SizedBox(height: 12),
            Text(
              'Belum ada course',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF51456B),
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Tambahkan course pertamamu untuk mulai mengelola data.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF9991A8), fontSize: 12),
            ),
          ],
        ),
      );
    }

    return Column(
      children: provider.courses.map((Course course) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CourseCard(
            course: course,
            isFavorite: provider.isFavorite(course.code),
            onFavoritePressed: () {
              provider.toggleFavorite(course.code);
            },
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DetailPage(course: course)),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}

class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  static Future<void> Function()? _reloadCallback;

  static Future<void> reload() async {
    await _reloadCallback?.call();
  }

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  late Future<UserProfile?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    ProfileCard._reloadCallback = _refreshProfile;
  }

  void _loadProfile() {
    _profileFuture = ProfileService().getMyProfile();
  }

  Future<void> _refreshProfile() async {
    setState(_loadProfile);
    await _profileFuture;
  }

  @override
  void dispose() {
    ProfileCard._reloadCallback = null;
    super.dispose();
  }

  String _roleLabel(String role) {
    switch (role) {
      case 'owner':
        return 'Pengelola';
      case 'admin':
        return 'Admin';
      default:
        return 'Mahasiswa';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile?>(
      future: _profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: CircularProgressIndicator(color: MainPage.primaryPurple),
            ),
          );
        }

        final profile = snapshot.data;

        if (snapshot.hasError || profile == null) {
          return Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFEAE3FF)),
            ),
            child: const Text(
              'Data profil belum tersedia. Pastikan akun memiliki data pada tabel profiles.',
              style: TextStyle(color: Color(0xFF89829A), fontSize: 12),
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFEAE3FF)),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFA6C9), Color(0xFFFFC5D9)],
                  ),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 31,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name.isEmpty
                          ? 'Pengguna Course Explorer'
                          : profile.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF30264A),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      profile.email,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF89829A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2EDFF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Role: ${_roleLabel(profile.role)}',
                        style: const TextStyle(
                          color: MainPage.primaryPurple,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.verified_rounded, color: Color(0xFF7B61D1)),
            ],
          ),
        );
      },
    );
  }
}
