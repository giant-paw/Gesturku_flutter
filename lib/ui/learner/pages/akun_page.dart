import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gesturku_app/ui/learner/pages/edit_profil_page.dart';
import 'package:google_fonts/google_fonts.dart'; 
import '../../../bloc/akun/akun_bloc.dart';
import '../../../bloc/auth/auth_bloc.dart';
import '../../../repositories/auth_repository.dart';

class AkunPage extends StatelessWidget {
  const AkunPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AkunBloc(
        authRepository: RepositoryProvider.of<AuthRepository>(context),
      )..add(FetchAkunData()),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is AuthAuthenticated) {
            final pengguna = authState.pengguna;
            final imageUrl = pengguna.pathFotoProfil != null && pengguna.pathFotoProfil!.isNotEmpty
                ? 'http://10.0.2.2:8000/files/${pengguna.pathFotoProfil}'
                : null;

            return Scaffold(
              backgroundColor: Colors.transparent, 
              appBar: AppBar(
                title: Text('Profil Saya', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                backgroundColor: Colors.transparent,
                elevation: 0,
                foregroundColor: Colors.black87,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit_note_rounded),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditProfilPage(pengguna: pengguna),
                        ),
                      );
                    },
                  )
                ],
              ),
              body: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
                          onBackgroundImageError: imageUrl != null ? (_, __) {} : null,
                          child: (imageUrl == null)
                              ? const Icon(Icons.person_rounded, size: 60, color: Colors.white)
                              : null,
                          backgroundColor: Colors.grey.shade400,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        pengguna.nama,
                        style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        pengguna.email,
                        style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  Text(
                    'Ringkasan Belajar',
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 4,
                    shadowColor: Colors.green.withOpacity(0.2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: BlocBuilder<AkunBloc, AkunState>(
                        builder: (context, akunState) {
                          if (akunState is AkunLoading || akunState is AkunInitial) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (akunState is AkunLoaded) {
                            return Row(
                              children: [
                                const Icon(Icons.school_rounded, color: Colors.green, size: 40),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${akunState.totalSelesai} Materi',
                                        style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                      const Text('Telah Berhasil Dikuasai', style: TextStyle(color: Colors.black54)),
                                    ],
                                  ),
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
                  const SizedBox(height: 32),

                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: Text('Logout', style: GoogleFonts.poppins(color: Colors.red, fontWeight: FontWeight.w600)),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          title: const Text('Konfirmasi Logout'),
                          content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Batal')),
                            TextButton(
                              onPressed: () {
                                context.read<AuthBloc>().add(LoggedOut());
                                Navigator.of(context).popUntil((route) => route.isFirst);
                              },
                              child: const Text('Ya, Keluar', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const Divider(),
                ],
              ),
            );
          }
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        },
      ),
    );
  }
}