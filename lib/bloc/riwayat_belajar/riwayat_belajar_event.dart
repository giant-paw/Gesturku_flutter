part of 'riwayat_belajar_bloc.dart';

abstract class RiwayatBelajarEvent extends Equatable {
  const RiwayatBelajarEvent();
  @override
  List<Object> get props => [];
}

class SimpanProgres extends RiwayatBelajarEvent {
  final int materiId;
  const SimpanProgres({required this.materiId});
  @override
  List<Object> get props => [materiId];
}