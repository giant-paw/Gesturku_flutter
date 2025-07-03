import 'package:equatable/equatable.dart';

class Materi extends Equatable {
  final int id;
  final String nama;
  final String? deskripsi;
  final String? urlVideo;
  final String? urlGambar;
  final bool isCompleted;
  final bool isUnlocked;

  const Materi({
    required this.id,
    required this.nama,
    this.deskripsi,
    this.urlVideo,
    this.urlGambar,
    this.isCompleted = false,
    this.isUnlocked = false,
  });

  factory Materi.fromJson(Map<String, dynamic> json) {
    return Materi(
      id: json['id'],
      nama: json['nama'],
      deskripsi: json['deskripsi'],
      urlVideo: json['url_video'],
      urlGambar: json['url_gambar'],
      isCompleted: json['is_completed'] ?? false,
      isUnlocked: json['is_unlocked'] ?? false,
    );
  }

  @override
  List<Object?> get props => [id, nama, deskripsi, urlVideo, urlGambar, isCompleted, isUnlocked];
}