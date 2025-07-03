import 'package:equatable/equatable.dart';

class Peringkat extends Equatable {
  final String nama;
  final String? pathFotoProfil;
  final int totalSelesai;

  const Peringkat({
    required this.nama,
    this.pathFotoProfil,
    required this.totalSelesai,
  });

  factory Peringkat.fromJson(Map<String, dynamic> json) {
    return Peringkat(
      nama: json['nama'],
      pathFotoProfil: json['path_foto_profil'],
      totalSelesai: json['total_selesai'],
    );
  }

  @override
  List<Object?> get props => [nama, pathFotoProfil, totalSelesai];
}