import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/kelola_materi/kelola_materi_bloc.dart';
import '../../../repositories/materi_repository.dart';

class KelolaMateriPage extends StatelessWidget {
  const KelolaMateriPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => KelolaMateriBloc(
        materiRepository: RepositoryProvider.of<MateriRepository>(context),
      )..add(FetchAllMateri()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Kelola Semua Materi'),
        ),
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
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: ListTile(
                      title: Text(materi.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Kategori: ${materi.kategori?.nama ?? 'N/A'}'),
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
            } else if (state is KelolaMateriError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text("Tidak ada data."));
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