import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../bloc/leaderboard/leaderboard_bloc.dart';
import '../../../models/peringkat.dart';
import '../../../repositories/leaderboard_repository.dart';

class InformasiPage extends StatelessWidget {
  const InformasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    const String baseUrl = 'http://10.0.2.2:8000';

    return BlocProvider(
      create: (context) => LeaderboardBloc(
        leaderboardRepository: RepositoryProvider.of<LeaderboardRepository>(context),
      )..add(FetchLeaderboard()),
      child: Scaffold(
        // Samakan background & AppBar dengan halaman Beranda
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Papan Peringkat', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black87,
        ),
        // Gunakan BlocBuilder untuk menampilkan UI sesuai state
        body: BlocBuilder<LeaderboardBloc, LeaderboardState>(
          builder: (context, state) {
            if (state is LeaderboardLoading || state is LeaderboardInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LeaderboardLoaded) {
              if (state.peringkat.isEmpty) {
                return const Center(child: Text('Belum ada data peringkat.'));
              }
              // Bungkus dengan RefreshIndicator untuk fitur pull-to-refresh
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<LeaderboardBloc>().add(FetchLeaderboard());
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  itemCount: state.peringkat.length,
                  itemBuilder: (context, index) {
                    final Peringkat itemPeringkat = state.peringkat[index];
                    final int rank = index + 1;
                    final imageUrl = itemPeringkat.pathFotoProfil != null
                        ? '$baseUrl/files/${itemPeringkat.pathFotoProfil}'
                        : null;

                    Widget rankWidget;
                    Color cardColor = Colors.white;

                    if (rank == 1) {
                      rankWidget = const Icon(Icons.emoji_events, color: Colors.amber, size: 30);
                      cardColor = Colors.amber.withOpacity(0.1);
                    } else if (rank == 2) {
                      rankWidget = const Icon(Icons.emoji_events, color: Colors.grey, size: 30);
                      cardColor = Colors.grey.withOpacity(0.1);
                    } else if (rank == 3) {
                      rankWidget = const Icon(Icons.emoji_events, color: Color(0xFFCD7F32), size: 30); // Warna perunggu
                      cardColor = const Color(0xFFCD7F32).withOpacity(0.1);
                    } else {
                      rankWidget = Text('$rank', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16));
                    }

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      color: cardColor,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(width: 30, child: Center(child: rankWidget)),
                            const SizedBox(width: 12),
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
                              onBackgroundImageError: imageUrl != null ? (_, __) {} : null,
                              child: (imageUrl == null) ? const Icon(Icons.person, size: 24) : null,
                            ),
                          ],
                        ),
                        title: Text(
                          itemPeringkat.nama,
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        trailing: Text(
                          '${itemPeringkat.totalSelesai} Poin',
                          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (state is LeaderboardError) {
              return Center(child: Text('Terjadi kesalahan: ${state.message}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}