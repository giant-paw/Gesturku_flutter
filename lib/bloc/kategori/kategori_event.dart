part of 'kategori_bloc.dart';

abstract class KategoriEvent extends Equatable {
  const KategoriEvent();

  @override
  List<Object> get props => [];
}

class FetchKategori extends KategoriEvent {}

class DeleteKategori extends KategoriEvent {
  final int kategoriId;
  const DeleteKategori({required this.kategoriId});
  @override
  List<Object> get props => [kategoriId];
}
