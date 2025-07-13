import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gesturku_app/ui/admin/pages/kelola_materi_page.dart';
import '../../bloc/auth/auth_bloc.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (dialogContext) => AlertDialog(
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
                            Navigator.of(
                              context,
                            ).popUntil((route) => route.isFirst);
                          },
                          child: const Text(
                            'Ya, Keluar',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 2,
            child: ListTile(
              leading: const Icon(
                Icons.video_library_rounded,
                color: Colors.blue,
              ),
              title: const Text(
                'Kelola Materi',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Tambah, ubah, atau hapus materi pembelajaran',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const KelolaMateriPage(),
                  ),
                );
              },
            ),
          ),

          Card(
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.category_rounded, color: Colors.orange),
              title: const Text(
                'Kelola Kategori',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Atur kategori pembelajaran'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                print('Masuk ke halaman Kelola Kategori');
              },
            ),
          ),

          Card(
            elevation: 2,
            child: ListTile(
              leading: const Icon(
                Icons.people_alt_rounded,
                color: Colors.green,
              ),
              title: const Text(
                'Lihat Pengguna',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Lihat daftar pengguna dan progresnya'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                print('Masuk ke halaman Lihat Pengguna');
              },
            ),
          ),
        ],
      ),
    );
  }
}
