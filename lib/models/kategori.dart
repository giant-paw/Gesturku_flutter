import 'package:equatable/equatable.dart';

class Kategori extends Equatable{
  final int id;
  final String nama;
  final String? deskripsi;
  final String? urlGambar;

  const Kategori({
    required this.id,
    required this.nama,
    this.deskripsi,
    this.urlGambar,
  });

  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      id: json['id'],
      nama: json['nama'],
      deskripsi: json['deskripsi'],
      urlGambar: json['url_gambar'],
    );
  }

  @override
  List<Object?> get props => [id, nama, deskripsi, urlGambar];
}