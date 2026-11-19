import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static const String _vapidKey =
      'BK9JAcmMwIOFcRQEowc6BVSofznLl2evCPE2fRqVspD5ovhH8ik9xIfTzJg5GJ-Md7MjloRDBrrT-GH9qUlE-ck';

  // Mendapatkan FCM Token.
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

  // Mendengarkan perubahan token.
  // ignore: deprecated_member_use
  void listenTokenRefresh(void Function(String token) onRefresh) {
    _messaging.onTokenRefresh.listen(
      (newToken) {
        debugPrint('FCM Token diperbarui.');
        debugPrint('FCM Token baru: $newToken');

        onRefresh(newToken);
      },
      onError: (error) {
        debugPrint('Token refresh error: $error');
      },
    );
  }
}
