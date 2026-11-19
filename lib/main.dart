import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_options.dart';
import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'screens/auth_gate.dart';
import 'screens/register_page.dart';
import 'services/course_supabase_service.dart';

const String supabaseUrl = 'https://svmrjenmzcujanzcaahv.supabase.co';

const String supabasePublishableKey =
    'sb_publishable_ak5DlExoB9yqZds6AadC8g_OBXAo9tr';

const String vapidKey =
    'BK9JAcmMwIOFcRQEowc6BVSofznLl2evCPE2fRqVspD5ovhH8ik9xIfTzJg5GJ-Md7MjloRDBrrT-GH9qUlE-ck';

// Handler notifikasi ketika aplikasi berada di background.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  debugPrint('Background notification: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inisialisasi Firebase.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 2. Registrasi background handler untuk Android.
  if (!kIsWeb) {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  // 3. Inisialisasi Supabase.
  await Supabase.initialize(
    url: supabaseUrl,
    publishableKey: supabasePublishableKey,
  );

  // 4. Menjalankan aplikasi.
  runApp(const MyApp());

  // 5. Konfigurasi Firebase Cloud Messaging.
  unawaited(configureFirebaseMessaging());
}

// Konfigurasi Firebase Cloud Messaging.
Future<void> configureFirebaseMessaging() async {
  try {
    final messaging = FirebaseMessaging.instance;

    // Mendengarkan notifikasi ketika aplikasi aktif.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint(
        'Foreground notification: '
        '${message.notification?.title}',
      );

      debugPrint('Message body: ${message.notification?.body}');
    });

    // Mendengarkan ketika notifikasi dibuka.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Notification opened: ${message.messageId}');
    });

    // Mendengarkan Firebase Installation ID.
    messaging.onRegistered.listen(
      (installationId) {
        debugPrint('Firebase Installation ID: $installationId');
      },
      onError: (error) {
        debugPrint('FCM Registration Error: $error');
      },
    );

    // Registrasi FCM berdasarkan platform.
    if (kIsWeb) {
      await messaging.register(
        vapidKey: vapidKey,
        serviceWorkerScriptPath: 'firebase-messaging-sw.js',
      );
    } else {
      await messaging.register();
    }

    debugPrint('FCM registration requested successfully.');
  } catch (e, stackTrace) {
    debugPrint('FCM initialization failed: $e');

    debugPrintStack(stackTrace: stackTrace);
  }
}

// Aplikasi utama Course Explorer.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          CourseProvider(CourseRepository(CourseSupabaseService()))
            ..loadCourses(),
      child: MaterialApp(
        title: 'Course Explorer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
        ),
        routes: {'/register': (context) => const RegisterPage()},
        home: const AuthGate(),
      ),
    );
  }
}
