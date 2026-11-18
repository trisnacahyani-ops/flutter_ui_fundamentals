import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'home_page.dart';
import 'login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService.instance.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          debugPrint('AUTH STREAM ERROR: ${snapshot.error}');

          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Gagal memeriksa autentikasi:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        final session = AuthService.instance.currentSession;

        debugPrint('AUTH STREAM STATE: ${snapshot.connectionState}');
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
