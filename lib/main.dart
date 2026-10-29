import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'screens/main_page.dart';
import 'services/course_supabase_service.dart';

const String supabaseUrl = 'https://svmrjenmzcujanzcaahv.supabase.co';

const String supabasePublishableKey =
    'sb_publishable_ak5DlExoB9yqZds6AadC8g_OBXAo9tr';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    publishableKey: supabasePublishableKey,
  );

  runApp(const MyApp());
}

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
        home: const MainPage(),
      ),
    );
  }
}
