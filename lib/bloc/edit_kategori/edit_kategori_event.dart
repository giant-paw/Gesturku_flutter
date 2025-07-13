part of 'edit_kategori_bloc.dart';

abstract class EditKategoriEvent extends Equatable {
  const EditKategoriEvent();

  @override
  List<Object?> get props => [];
}

class SimpanPerubahanKategori extends EditKategoriEvent {
  final int kategoriId;
  final String nama;
  final String? deskripsi;
  final int urutan;
  final XFile? gambar; 

  const SimpanPerubahanKategori({
    required this.kategoriId,
    required this.nama,
    this.deskripsi,
    required this.urutan,
    this.gambar,
  });

  @override
  List<Object?> get props => [kategoriId, nama, deskripsi, urutan, gambar];
}