import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gesturku_app/bloc/materi/materi_bloc.dart';
import 'package:gesturku_app/repositories/materi_repository.dart';
import 'package:gesturku_app/ui/learner/pages/materi_detail_page.dart';

class MateriListPage extends StatelessWidget {
  final int kategoriId;
  final String kategoriNama;

  const MateriListPage({
    super.key,
    required this.kategoriId,
    required this.kategoriNama,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => MateriBloc(
            materiRepository: RepositoryProvider.of<MateriRepository>(context),
          )..add(FetchMateriByKategori(kategoriId: kategoriId)),
      child: Scaffold(
        appBar: AppBar(title: Text(kategoriNama)),
        body: BlocBuilder<MateriBloc, MateriState>(
          builder: (context, state) {
            if (state is MateriLoading || state is MateriInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MateriLoaded) {
              if (state.materi.isEmpty) {
                return const Center(
                  child: Text('Belum ada materi di kategori ini.'),
                );
              }
              return ListView.builder(
                itemCount: state.materi.length,
                itemBuilder: (context, index) {
                  final materi = state.materi[index];
                  final bool isLocked =
                      !materi.isUnlocked; 

                  return ListTile(
                    leading: Icon(
                      materi.isCompleted
                          ? Icons.check_circle
                          : Icons.video_library_outlined,
                      color:
                          isLocked
                              ? Colors.grey.shade400
                              : (materi.isCompleted
                                  ? Colors.green
                                  : Theme.of(context).primaryColor),
                    ),
                    title: Text(
                      materi.nama,
                      style: TextStyle(
                        decoration:
                            materi.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                        color: isLocked ? Colors.grey.shade400 : null,
                      ),
                    ),
                    trailing:
                        isLocked
                            ? const Icon(Icons.lock, color: Colors.grey)
                            : (materi.isCompleted
                                ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                                : const Icon(Icons.chevron_right)),
                    onTap:
                        isLocked
                            ? null
                            : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => BlocProvider.value(
                                        value: BlocProvider.of<MateriBloc>(
                                          context,
                                        ),
                                        child: MateriDetailPage(materi: materi),
                                      ),
                                ),
                              );
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
