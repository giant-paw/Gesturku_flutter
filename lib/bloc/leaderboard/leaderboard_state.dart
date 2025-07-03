part of 'leaderboard_bloc.dart';

abstract class LeaderboardState extends Equatable {
  const LeaderboardState();
  @override
  List<Object> get props => [];
}

class LeaderboardInitial extends LeaderboardState {}

class LeaderboardLoading extends LeaderboardState {}

class LeaderboardLoaded extends LeaderboardState {
  final List<Peringkat> peringkat;
  const LeaderboardLoaded({required this.peringkat});
  @override
  List<Object> get props => [peringkat];
}

class LeaderboardError extends LeaderboardState {
  final String message;
  const LeaderboardError({required this.message});
  @override
  List<Object> get props => [message];
}
