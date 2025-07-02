import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gesturku_app/repositories/deteksi_repository.dart';
import 'package:gesturku_app/repositories/kategori_repository.dart';
import 'package:gesturku_app/repositories/materi_repository.dart';
import 'package:gesturku_app/repositories/riwayat_belajar_repository.dart';
import 'bloc/auth/auth_bloc.dart';
import 'repositories/auth_repository.dart';
import 'ui/admin/admin_home_page.dart';
import 'ui/learner/main_learner_page.dart'; // <-- GANTI INI
import 'ui/login/login_page.dart';
import 'ui/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Menyediakan semua repository di tingkat atas
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => KategoriRepository()),
        RepositoryProvider(create: (context) => MateriRepository(),),
        RepositoryProvider(create: (context) => DeteksiRepository()), 
        RepositoryProvider(create: (context) => RiwayatBelajarRepository()), 
      ],
      child: BlocProvider(
        create: (context) => AuthBloc(
          authRepository: RepositoryProvider.of<AuthRepository>(context),
        )..add(AppStarted()),
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
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthUninitialized) {
          return const SplashScreen();
        } else if (state is AuthAuthenticated) {
          if (state.pengguna.role == 'admin') {
            return const AdminHomePage();
          } else {
            return const MainLearnerPage(); // <-- UBAH INI
          }
        } else if (state is AuthUnauthenticated) {
          return const LoginPage();
        } else if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return const SplashScreen();
      },
    );
  }
}