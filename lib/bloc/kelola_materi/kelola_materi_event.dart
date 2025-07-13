part of 'kelola_materi_bloc.dart';

abstract class KelolaMateriEvent extends Equatable {
  const KelolaMateriEvent();
  @override
  List<Object> get props => [];
}

class DeleteMateri extends KelolaMateriEvent {
  final int materiId;
  const DeleteMateri({required this.materiId});
  @override
  List<Object> get props => [materiId];
}

class FetchAllMateri extends KelolaMateriEvent {}
