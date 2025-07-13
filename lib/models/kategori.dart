import 'package:equatable/equatable.dart';

class Kategori extends Equatable{
  final int id;
  final String nama;
  final String? deskripsi;
  final String? urlGambar;
  final int urutan;

  const Kategori({
    required this.id,
    required this.nama,
    this.deskripsi,
    this.urlGambar,
    required this.urutan,
  });

  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      id: json['id'],
      nama: json['nama'],
      deskripsi: json['deskripsi'],
      urlGambar: json['url_gambar'],
      urutan: json['urutan'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [id, nama, deskripsi, urlGambar];
}