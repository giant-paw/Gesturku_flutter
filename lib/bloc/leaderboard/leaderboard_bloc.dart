import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/peringkat.dart';
import '../../repositories/leaderboard_repository.dart';

part 'leaderboard_event.dart';
part 'leaderboard_state.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  final LeaderboardRepository leaderboardRepository;

  LeaderboardBloc({required this.leaderboardRepository})
    : super(LeaderboardInitial()) {
    on<FetchLeaderboard>(_onFetchLeaderboard);
  }

  void _onFetchLeaderboard(
    FetchLeaderboard event,
    Emitter<LeaderboardState> emit,
  ) async {
    emit(LeaderboardLoading());
    try {
      final leaderboardData = await leaderboardRepository.fetchLeaderboard();
      emit(LeaderboardLoaded(peringkat: leaderboardData));
    } catch (e) {
      emit(LeaderboardError(message: e.toString()));
    }
  }
}
