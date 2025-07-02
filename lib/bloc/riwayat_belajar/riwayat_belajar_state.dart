part of 'riwayat_belajar_bloc.dart';

abstract class RiwayatBelajarState extends Equatable {
  const RiwayatBelajarState();
  @override
  List<Object> get props => [];
}

class RiwayatBelajarInitial extends RiwayatBelajarState {}
class RiwayatBelajarLoading extends RiwayatBelajarState {}
class RiwayatBelajarSukses extends RiwayatBelajarState {}

class RiwayatBelajarError extends RiwayatBelajarState {
  final String message;
  const RiwayatBelajarError({required this.message});
  @override
  List<Object> get props => [message];
}