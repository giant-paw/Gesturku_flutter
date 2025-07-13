import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gesturku_app/ui/admin/pages/edit_kategori_page.dart';
import 'package:gesturku_app/ui/admin/pages/tambah_kategori_page.dart';
import '../../../bloc/kategori/kategori_bloc.dart';
import '../../../repositories/kategori_repository.dart';

class KelolaKategoriPage extends StatelessWidget {
  const KelolaKategoriPage({super.key});

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
        appBar: AppBar(title: const Text('Kelola Kategori')),
        body: BlocBuilder<KategoriBloc, KategoriState>(
          builder: (context, state) {
            if (state is KategoriLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is KategoriLoaded) {
              return ListView.builder(
                itemCount: state.kategori.length,
                itemBuilder: (context, index) {
                  final kategori = state.kategori[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          'http://10.0.2.2:8000/files/${kategori.urlGambar}',
                        ),
                        onBackgroundImageError: (_, __) {},
                        child:
                            kategori.urlGambar == null
                                ? const Icon(Icons.category)
                                : null,
                      ),
                      title: Text(
                        kategori.nama,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        kategori.deskripsi ?? 'Tidak ada deskripsi',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => EditKategoriPage(
                                        kategoriToEdit: kategori,
                                      ),
                                ),
                              );
                              if (result == true && context.mounted) {
                                context.read<KategoriBloc>().add(
                                  FetchKategori(),
                                );
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder:
                                    (dialogContext) => AlertDialog(
                                      title: const Text('Konfirmasi Hapus'),
                                      content: Text(
                                        'Yakin ingin menghapus kategori "${kategori.nama}"? Semua materi di dalamnya juga akan terhapus.',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.pop(dialogContext),
                                          child: const Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            context.read<KategoriBloc>().add(
                                              DeleteKategori(
                                                kategoriId: kategori.id,
                                              ),
                                            );
                                            Navigator.pop(dialogContext);
                                          },
                                          child: const Text(
                                            'Ya, Hapus',
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
                    ),
                  );
                },
              );
            } else if (state is KategoriError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text("Tidak ada data kategori."));
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const TambahKategoriPage()));
            if (result == true && context.mounted) {
              context.read<KategoriBloc>().add(FetchKategori());
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
