part of 'tambah_materi_bloc.dart';

abstract class TambahMateriEvent extends Equatable {
  const TambahMateriEvent();
  @override
  List<Object?> get props => [];
}

class SimpanMateriBaru extends TambahMateriEvent {
  final String nama;
  final int kategoriId;
  final String deskripsi;
  final int urutan;
  final XFile file;

  const SimpanMateriBaru({
    required this.nama,
    required this.kategoriId,
    required this.deskripsi,
    required this.urutan,
    required this.file,
  });

  @override
  List<Object?> get props => [nama, kategoriId, deskripsi, urutan, file];
}