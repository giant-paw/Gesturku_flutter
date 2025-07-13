import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gesturku_app/ui/admin/pages/edit_materi_page.dart';
import 'package:gesturku_app/ui/admin/pages/tambah_materi_page.dart';
import '../../../bloc/kelola_materi/kelola_materi_bloc.dart';
import '../../../repositories/materi_repository.dart';

class KelolaMateriPage extends StatelessWidget {
  const KelolaMateriPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => KelolaMateriBloc(
            materiRepository: RepositoryProvider.of<MateriRepository>(context),
          )..add(FetchAllMateri()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Kelola Semua Materi')),
        body: BlocBuilder<KelolaMateriBloc, KelolaMateriState>(
          builder: (context, state) {
            if (state is KelolaMateriLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is KelolaMateriLoaded) {
              return ListView.builder(
                itemCount: state.materi.length,
                itemBuilder: (context, index) {
                  final materi = state.materi[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    child: ListTile(
                      title: Text(
                        materi.nama,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Kategori: ${materi.kategori?.nama ?? 'N/A'}',
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
                                      (context) =>
                                          EditMateriPage(materiToEdit: materi),
                                ),
                              );

                              if (result == true) {
                                context.read<KelolaMateriBloc>().add(
                                  FetchAllMateri(),
                                );
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // Tampilkan dialog konfirmasi
                              showDialog(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return AlertDialog(
                                    title: const Text('Konfirmasi Hapus'),
                                    content: Text(
                                      'Apakah Anda yakin ingin menghapus materi "${materi.nama}"?',
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Batal'),
                                        onPressed:
                                            () =>
                                                Navigator.of(
                                                  dialogContext,
                                                ).pop(),
                                      ),
                                      TextButton(
                                        child: const Text(
                                          'Ya, Hapus',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () {
                                          context.read<KelolaMateriBloc>().add(
                                            DeleteMateri(materiId: materi.id),
                                          );
                                          Navigator.of(dialogContext).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is KelolaMateriError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text("Tidak ada data."));
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TambahMateriPage()),
            );

            if (result == true && context.mounted) {
              context.read<KelolaMateriBloc>().add(FetchAllMateri());
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
