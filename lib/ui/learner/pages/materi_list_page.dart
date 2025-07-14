import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gesturku_app/bloc/materi/materi_bloc.dart';
import 'package:gesturku_app/repositories/materi_repository.dart';
import 'package:gesturku_app/ui/learner/pages/materi_detail_page.dart';
import 'package:google_fonts/google_fonts.dart'; // <-- Import Google Fonts

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
      create: (context) => MateriBloc(
        materiRepository: RepositoryProvider.of<MateriRepository>(context),
      )..add(FetchMateriByKategori(kategoriId: kategoriId)),
      child: Scaffold(
        backgroundColor: const Color(0xFFE8F5E9), 
        appBar: AppBar(
          title: Text(kategoriNama),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black87,
        ),
        body: BlocBuilder<MateriBloc, MateriState>(
          builder: (context, state) {
            if (state is MateriLoading || state is MateriInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MateriLoaded) {
              if (state.materi.isEmpty) {
                return const Center(child: Text('Belum ada materi di kategori ini.'));
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16.0),
                itemCount: state.materi.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final materi = state.materi[index];
                  final bool isLocked = !materi.isUnlocked;

                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isLocked ? Colors.grey.shade300 : Colors.green.shade200,
                      ),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: isLocked
                          ? null 
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: BlocProvider.of<MateriBloc>(context),
                                    child: MateriDetailPage(materi: materi),
                                  ),
                                ),
                              );
                            },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(
                              materi.isCompleted ? Icons.check_circle : (isLocked ? Icons.lock : Icons.play_circle_fill),
                              color: isLocked ? Colors.grey.shade400 : (materi.isCompleted ? Colors.green : Colors.blue),
                              size: 36,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    materi.nama,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: isLocked ? Colors.grey.shade500 : Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    materi.isCompleted ? "Selesai Dipelajari" : (isLocked ? "Terkunci" : "Mulai Belajar"),
                                    style: TextStyle(color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ),
                            if (!isLocked)
                              const Icon(Icons.chevron_right, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
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