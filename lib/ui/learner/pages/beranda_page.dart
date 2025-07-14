import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gesturku_app/bloc/auth/auth_bloc.dart';
import 'package:gesturku_app/ui/learner/pages/materi_list_page.dart';
import '../../../bloc/kategori/kategori_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../repositories/kategori_repository.dart';

class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => KategoriBloc(
            kategoriRepository: RepositoryProvider.of<KategoriRepository>(
              context,
            ),
          )..add(FetchKategori()),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            'Beranda',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: BlocBuilder<KategoriBloc, KategoriState>(
          builder: (context, state) {
            if (state is KategoriLoading || state is KategoriInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is KategoriLoaded) {
              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, authState) {
                        if (authState is AuthAuthenticated) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Halo, ${authState.pengguna.nama}!',
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Siap belajar apa hari ini?',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio: 0.85,
                        ),
                    itemCount: state.kategori.length,
                    itemBuilder: (context, index) {
                      final kategori = state.kategori[index];
                      final imageUrl =
                          kategori.urlGambar != null
                              ? 'http://10.0.2.2:8000/files/${kategori.urlGambar}'
                              : null;

                      // Card dengan gaya modern
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => BlocProvider.value(
                                      value: BlocProvider.of<KategoriBloc>(
                                        context,
                                      ),
                                      child: MateriListPage(
                                        kategoriId: kategori.id,
                                        kategoriNama: kategori.nama,
                                      ),
                                    ),
                              ),
                            );
                          },
                          child: Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              // Layer 1: Gambar sebagai background
                              if (imageUrl != null)
                                Positioned.fill(
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  ),
                                ),

                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black.withOpacity(0.7),
                                      Colors.transparent,
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.center,
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  kategori.nama,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 2.0,
                                        color: Colors.black54,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            } else if (state is KategoriError) {
              return Center(child: Text('Terjadi kesalahan: ${state.message}'));
            }
            return const Center(child: Text('Silakan mulai belajar.'));
          },
        ),
      ),
    );
  }
}
