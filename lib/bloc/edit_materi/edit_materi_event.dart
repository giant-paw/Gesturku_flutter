part of 'edit_materi_bloc.dart';

abstract class EditMateriEvent extends Equatable {
  const EditMateriEvent();
  @override
  List<Object?> get props => [];
}

class SimpanPerubahanMateri extends EditMateriEvent {
  final int materiId;
  final String nama;
  final int kategoriId;
  final String deskripsi;
  final int urutan;
  final XFile? file; // File bersifat opsional

  const SimpanPerubahanMateri({
    required this.materiId,
    required this.nama,
    required this.kategoriId,
    required this.deskripsi,
    required this.urutan,
    this.file,
  });

  @override
  List<Object?> get props => [materiId, nama, kategoriId, deskripsi, urutan, file];
}