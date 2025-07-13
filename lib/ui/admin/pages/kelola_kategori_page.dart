import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                        onBackgroundImageError:
                            (_, __) {}, 
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
                            onPressed: () {
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
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
          onPressed: () {
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
