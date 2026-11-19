import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/auth_service.dart';
import 'home_page.dart';
import 'login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: AuthService.instance.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                'Gagal memeriksa autentikasi:\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final session =
            snapshot.data?.session ?? AuthService.instance.currentSession;

        debugPrint('AUTH EVENT: ${snapshot.data?.event}');
        debugPrint('SESSION EXISTS: ${session != null}');

        if (session != null) {
          debugPrint('AUTH GATE: Membuka HomePage');
          return const HomePage();
        }

        debugPrint('AUTH GATE: Membuka LoginPage');
        return const LoginPage();
      },
    );
  }
}
