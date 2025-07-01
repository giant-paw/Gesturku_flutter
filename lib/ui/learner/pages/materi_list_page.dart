import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gesturku_app/bloc/materi/materi_bloc.dart';
import 'package:gesturku_app/repositories/materi_repository.dart';

class MateriListPage extends StatelessWidget {
  final int kategoriId;
  final String kategoriNama;

  const MateriListPage({
    super.key,
    required this.kategoriId,
    required this.kategoriNama  
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MateriBloc(
        materiRepository: RepositoryProvider.of<MateriRepository>(context),
      )..add(FetchMateriByKategori(kategoriId: kategoriId)), 
      child: Scaffold(
        appBar: AppBar(
          title: Text(kategoriNama),
        ),
        body: BlocBuilder<MateriBloc, MateriState>(
          builder: (context, state) {
            if (state is MateriLoading || state is MateriInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MateriLoaded) {
              if (state.materi.isEmpty) {
                return const Center(child: Text('Belum ada materi di kategori ini.'));
              }
              // Jika ada materi, tampilkan sebagai daftar
              return ListView.builder(
                itemCount: state.materi.length,
                itemBuilder: (context, index) {
                  final materi = state.materi[index];
                  return ListTile(
                    leading: const Icon(Icons.video_library_outlined),
                    title: Text(materi.nama),
                    onTap: () {
                      print('Tapped on materi: ${materi.nama}');
                    },
                  );
                },
              );
            } else if (state is MateriError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const SizedBox.shrink(); 
          },
        ),
      ),
    );
  }
}