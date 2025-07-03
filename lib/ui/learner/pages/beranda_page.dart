import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gesturku_app/ui/learner/pages/materi_list_page.dart';
import '../../../bloc/kategori/kategori_bloc.dart';
import '../../../repositories/kategori_repository.dart';

class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Membuat instance KategoriBloc dan langsung memicu event FetchKategori
      create: (context) => KategoriBloc(
        kategoriRepository: RepositoryProvider.of<KategoriRepository>(context),
      )..add(FetchKategori()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pilih Kategori Belajar'),
        ),
        body: BlocBuilder<KategoriBloc, KategoriState>(
          builder: (context, state) {
            // Tampilkan indikator loading saat data diambil
            if (state is KategoriLoading || state is KategoriInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            // Tampilkan daftar kategori jika data berhasil dimuat
            else if (state is KategoriLoaded) {
              return GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, 
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.8, 
                ),
                itemCount: state.kategori.length,
                itemBuilder: (context, index) {
                  final kategori = state.kategori[index];

                  const String baseUrl = 'http://10.0.2.2:8000'; 

                  // Alamat lengkap untuk gambar
                  final String imageUrl = '$baseUrl/files/${kategori.urlGambar}';

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
                            builder: (context) => MateriListPage(
                              kategoriId: kategori.id, 
                              kategoriNama: kategori.nama
                            ),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                return progress == null ? child : const Center(child: CircularProgressIndicator());
                              },
                              errorBuilder: (context, error, stackTrace) {
                                print('Error memuat gambar: $error'); 
                                return const Icon(Icons.image_not_supported, size: 50, color: Colors.grey);
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              kategori.nama,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            else if (state is KategoriError) {
              return Center(child: Text('Terjadi kesalahan: ${state.message}'));
            }
            return const Center(child: Text('Silakan mulai belajar.'));
          },
        ),
      ),
    );
  }
}