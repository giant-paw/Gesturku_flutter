part of 'tambah_kategori_bloc.dart';

abstract class TambahKategoriEvent extends Equatable {
  const TambahKategoriEvent();

  @override
  List<Object?> get props => [];
}

class SimpanKategoriBaru extends TambahKategoriEvent {
  final String nama;
  final String? deskripsi;
  final int urutan;
  final XFile? gambar; // Gambar bersifat opsional

  const SimpanKategoriBaru({
    required this.nama,
    this.deskripsi,
    required this.urutan,
    this.gambar,
  });

  @override
  List<Object?> get props => [nama, deskripsi, urutan, gambar];
}