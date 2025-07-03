import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/akun/akun_bloc.dart';
import '../../../bloc/auth/auth_bloc.dart';
import '../../../models/pengguna.dart';
import '../../../repositories/auth_repository.dart';

class AkunPage extends StatelessWidget {
  const AkunPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AkunBloc(
        authRepository: RepositoryProvider.of<AuthRepository>(context),
      )..add(FetchAkunData()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profil Saya'),
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
        ),
        // Gunakan BlocBuilder untuk AuthBloc agar kita mendapatkan data pengguna dengan aman
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            // Hanya bangun UI jika state-nya adalah AuthAuthenticated
            if (authState is AuthAuthenticated) {
              final pengguna = authState.pengguna;

              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  // --- Bagian Header Profil ---
                  Column(
                    children: [
                      // Gunakan pengecekan yang sudah benar
                      if (pengguna.pathFotoProfil != null && pengguna.pathFotoProfil!.isNotEmpty)
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                            'http://10.0.2.2:8000/files/${pengguna.pathFotoProfil}',
                          ),
                        )
                      else
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.person, size: 50, color: Colors.white),
                        ),

                      const SizedBox(height: 16),
                      Text(
                        pengguna.nama,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        pengguna.email,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),

                  // --- Bagian Ringkasan Progres ---
                  const Text(
                    'Ringkasan Belajar',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: BlocBuilder<AkunBloc, AkunState>(
                        builder: (context, akunState) {
                          if (akunState is AkunLoading || akunState is AkunInitial) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (akunState is AkunLoaded) {
                            return Row(
                              children: [
                                const Icon(Icons.check_circle_outline, color: Colors.green, size: 40),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${akunState.totalSelesai}',
                                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                    ),
                                    const Text('Materi Telah Dikuasai'),
                                  ],
                                ),
                              ],
                            );
                          } else if (akunState is AkunError) {
                            return Text('Gagal memuat progres: ${akunState.message}');
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- Bagian Tombol Logout ---
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Logout', style: TextStyle(color: Colors.red)),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text('Konfirmasi Logout'),
                          content: const Text('Apakah Anda yakin ingin keluar?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(dialogContext).pop(),
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<AuthBloc>().add(LoggedOut());
                                Navigator.of(dialogContext).pop();
                              },
                              child: const Text('Ya, Keluar', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              );
            }

            // Jika state bukan AuthAuthenticated (misalnya saat proses logout), tampilkan loading
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}