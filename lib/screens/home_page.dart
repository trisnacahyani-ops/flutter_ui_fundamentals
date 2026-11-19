import 'package:flutter/material.dart';

import '../services/notification_service.dart';
import 'main_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _initializeFCMToken();
  }

  Future<void> _initializeFCMToken() async {
    final notificationService = NotificationService.instance;

    try {
      // 1. Mendapatkan FCM Token.
      final token = await notificationService.getToken();

      if (token != null) {
        debugPrint('FCM Token berhasil diperoleh.');
      }

      // 2. Mendengarkan perubahan token.
      notificationService.listenTokenRefresh((newToken) {
        debugPrint('Token berhasil diperbarui.');
      });
    } catch (e) {
      debugPrint('FCM Token error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const MainPage();
  }
}
