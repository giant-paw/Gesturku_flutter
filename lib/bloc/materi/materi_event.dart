part of 'materi_bloc.dart';

abstract class MateriEvent extends Equatable {
  const MateriEvent();
  @override
  List<Object> get props => [];
}

// Berdasarkan kategoriID
class FetchMateriByKategori extends MateriEvent {
  final int kategoriId;
  const FetchMateriByKategori({required this.kategoriId});
  @override
  List<Object> get props => [kategoriId];
}