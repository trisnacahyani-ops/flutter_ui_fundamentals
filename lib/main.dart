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
import 'services/notification_service.dart';

// Konfigurasi Supabase.
const String supabaseUrl = 'https://svmrjenmzcujanzcaahv.supabase.co';

const String supabasePublishableKey =
    'sb_publishable_ak5DlExoB9yqZds6AadC8g_OBXAo9tr';

// ==========================================
// BACKGROUND NOTIFICATION HANDLER
// ==========================================

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  debugPrint('[BACKGROUND] Notification received');

  debugPrint('title: ${message.notification?.title}');

  debugPrint('body: ${message.notification?.body}');

  debugPrint('data: ${message.data}');
}

// ==========================================
// MAIN
// ==========================================

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inisialisasi Firebase.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 2. Registrasi background handler.
  // Web menggunakan Firebase Service Worker.
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
}

// ==========================================
// MY APP
// ==========================================

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

        // Key untuk menampilkan SnackBar notifikasi.
        scaffoldMessengerKey: NotificationService.messengerKey,

        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
        ),

        // Routing aplikasi.
        routes: {'/register': (context) => const RegisterPage()},

        // Halaman utama berdasarkan status autentikasi.
        home: const AuthGate(),
      ),
    );
  }
}
