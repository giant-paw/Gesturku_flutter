import 'package:equatable/equatable.dart';

class Materi extends Equatable {
  final int id;
  final String nama;
  final String? deskripsi;
  final String? urlVideo;
  final String? urlGambar;

  const Materi({
    required this.id,
    required this.nama,
    this.deskripsi,
    this.urlVideo,
    this.urlGambar,
  });

  factory Materi.fromJson(Map<String, dynamic> json) {
    return Materi(
      id: json['id'],
      nama: json['nama'],
      deskripsi: json['deskripsi'],
      urlVideo: json['url_video'],
      urlGambar: json['url_gambar'],
    );
  }

  @override
  List<Object?> get props => [id, nama, deskripsi, urlVideo, urlGambar];
}