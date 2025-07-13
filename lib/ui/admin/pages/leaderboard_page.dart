import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/leaderboard/leaderboard_bloc.dart';
import '../../../repositories/leaderboard_repository.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LeaderboardBloc(
        leaderboardRepository: RepositoryProvider.of<LeaderboardRepository>(context),
      )..add(FetchLeaderboard()), 
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Papan Peringkat Pengguna'),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<LeaderboardBloc>().add(FetchLeaderboard());
          },
          child: BlocBuilder<LeaderboardBloc, LeaderboardState>(
            builder: (context, state) {
              if (state is LeaderboardLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is LeaderboardLoaded) {
                if (state.peringkat.isEmpty) {
                  return const Center(child: Text('Belum ada data peringkat.'));
                }
                return ListView.builder(
                  itemCount: state.peringkat.length,
                  itemBuilder: (context, index) {
                    final user = state.peringkat[index];
                    final rank = index + 1;
                    
                    Widget rankIcon;
                    Color rankColor;
                    if (rank == 1) {
                      rankIcon = const Icon(Icons.emoji_events, color: Colors.amber);
                      rankColor = Colors.amber.shade100;
                    } else if (rank == 2) {
                      rankIcon = const Icon(Icons.emoji_events, color: Colors.grey);
                      rankColor = Colors.grey.shade200;
                    } else if (rank == 3) {
                      rankIcon = const Icon(Icons.emoji_events, color: Colors.brown);
                      rankColor = Colors.brown.shade100;
                    } else {
                      rankIcon = CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        child: Text('$rank'),
                      );
                      rankColor = Colors.transparent;
                    }

                    return Card(
                      color: rankColor,
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: rankIcon,
                        title: Text(user.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
                        trailing: Text('${user.totalSelesai} materi', style: const TextStyle(fontSize: 16)),
                      ),
                    );
                  },
                );
              } else if (state is LeaderboardError) {
                return Center(child: Text(state.message));
              }
              return const Center(child: Text("Silakan coba lagi."));
            },
          ),
        ),
      ),
    );
  }
}