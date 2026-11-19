import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static const String _vapidKey =
      'BK9JAcmMwIOFcRQEowc6BVSofznLl2evCPE2fRqVspD5ovhH8ik9xIfTzJg5GJ-Md7MjloRDBrrT-GH9qUlE-ck';

  bool _initialized = false;

  // Praktik 9: Mendapatkan FCM Token.
  // ignore: deprecated_member_use
  Future<String?> getToken() async {
    try {
      final token = await _messaging.getToken(
        vapidKey: kIsWeb ? _vapidKey : null,
      );

      if (token != null) {
        debugPrint('FCM Token: $token');
      } else {
        debugPrint('FCM Token belum tersedia.');
      }

      return token;
    } catch (e) {
      debugPrint('Gagal mendapatkan FCM Token: $e');
      return null;
    }
  }

  // Praktik 9: Mendengarkan perubahan token.
  // ignore: deprecated_member_use
  void listenTokenRefresh(void Function(String token) onRefresh) {
    _messaging.onTokenRefresh.listen(
      (newToken) {
        debugPrint('FCM Token diperbarui.');
        onRefresh(newToken);
      },
      onError: (error) {
        debugPrint('Token refresh error: $error');
      },
    );
  }

  // Praktik 10: Inisialisasi notification listener.
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    try {
      // Mengambil FCM Token.
      final token = await getToken();

      if (token != null) {
        debugPrint('FCM Token berhasil diperoleh.');
      }

      // Mendengarkan perubahan token.
      listenTokenRefresh((newToken) {
        debugPrint('Token berhasil diperbarui.');
      });

      // Pengaturan notifikasi foreground untuk iOS.
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // FOREGROUND: aplikasi sedang terbuka.
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('[FOREGROUND] Notification received');
        debugPrint('title: ${message.notification?.title}');
        debugPrint('body : ${message.notification?.body}');
        debugPrint('data : ${message.data}');

        final title = message.notification?.title ?? 'Notifikasi';

        final body = message.notification?.body ?? '';

        messengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text('$title\n$body'),
            duration: const Duration(seconds: 5),
          ),
        );
      });

      // BACKGROUND: pengguna membuka notifikasi.
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('[BACKGROUND] Notification opened');
        debugPrint('title: ${message.notification?.title}');
        debugPrint('body: ${message.notification?.body}');
        debugPrint('data: ${message.data}');
      });

      // TERMINATED: aplikasi dibuka melalui notifikasi.
      final initialMessage = await _messaging.getInitialMessage();

      if (initialMessage != null) {
        debugPrint('[TERMINATED] Notification opened');
        debugPrint('title: ${initialMessage.notification?.title}');
        debugPrint('body: ${initialMessage.notification?.body}');
        debugPrint('data: ${initialMessage.data}');
      }

      debugPrint('Notification listeners initialized.');
    } catch (e, stackTrace) {
      debugPrint('Notification initialization error: $e');
      debugPrintStack(stackTrace: stackTrace);
      _initialized = false;
    }
  }
}
