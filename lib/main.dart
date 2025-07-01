import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/auth/auth_bloc.dart';
import 'repositories/auth_repository.dart';
import 'ui/admin/admin_home_page.dart';
import 'ui/learner/learner_home_page.dart';
import 'ui/login/login_page.dart';
import 'ui/splash_screen.dart'; // Kita buat splash screen sederhana

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Menyediakan AuthRepository dan AuthBloc ke seluruh aplikasi
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) => AuthBloc(
          authRepository: RepositoryProvider.of<AuthRepository>(context),
        )..add(AppStarted()), // Langsung jalankan event AppStarted
        child: MaterialApp(
          title: 'Gesturku',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const AppRouter(),
        ),
      ),
    );
  }
}

class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    // BlocBuilder akan "membangun ulang" widget berdasarkan state AuthBloc
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthUninitialized) {
          return const SplashScreen(); // Tampilkan splash screen saat inisialisasi
        } else if (state is AuthAuthenticated) {
          // Logika Navigasi Berbasis Peran
          if (state.pengguna.role == 'admin') {
            return const AdminHomePage();
          } else {
            return const LearnerHomePage();
          }
        } else if (state is AuthUnauthenticated) {
          return const LoginPage();
        } else if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return const SplashScreen(); // Default fallback
      },
    );
  }
}