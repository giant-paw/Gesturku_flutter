import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/leaderboard/leaderboard_bloc.dart';
import '../../../models/peringkat.dart';
import '../../../repositories/leaderboard_repository.dart';

class InformasiPage extends StatelessWidget {
  const InformasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LeaderboardBloc(
        leaderboardRepository: RepositoryProvider.of<LeaderboardRepository>(context),
      )..add(FetchLeaderboard()), 
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Papan Peringkat'),
        ),
        body: BlocBuilder<LeaderboardBloc, LeaderboardState>(
          builder: (context, state) {
            if (state is LeaderboardLoading || state is LeaderboardInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            else if (state is LeaderboardLoaded) {
              if (state.peringkat.isEmpty) {
                return const Center(
                  child: Text('Belum ada data peringkat.'),
                );
              }
              return ListView.builder(
                itemCount: state.peringkat.length,
                itemBuilder: (context, index) {
                  final Peringkat itemPeringkat = state.peringkat[index];
                  final int rank = index + 1;

                  Widget leadingWidget;
                  if (rank == 1) {
                    leadingWidget = const Icon(Icons.emoji_events, color: Colors.amber, size: 40);
                  } else if (rank == 2) {
                    leadingWidget = const Icon(Icons.emoji_events, color: Colors.grey, size: 40);
                  } else if (rank == 3) {
                    leadingWidget = const Icon(Icons.emoji_events, color: Color(0xFFCD7F32), size: 40); // Warna perunggu
                  } else {
                    leadingWidget = CircleAvatar(child: Text('$rank'));
                  }

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    elevation: 2,
                    child: ListTile(
                      leading: leadingWidget,
                      title: Text(
                        itemPeringkat.nama,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${itemPeringkat.totalSelesai}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const Text('Materi', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            else if (state is LeaderboardError) {
              return Center(child: Text('Terjadi kesalahan: ${state.message}'));
            }
            return const SizedBox.shrink(); 
          },
        ),
      ),
    );
  }
}