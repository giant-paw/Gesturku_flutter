import 'package:equatable/equatable.dart';
import 'kategori.dart';

class Materi extends Equatable {
  final int id;
  final String nama;
  final String? deskripsi;
  final String? urlVideo;
  final String? urlGambar;
  final int urutan;
  final bool isCompleted;
  final bool isUnlocked;
  final Kategori? kategori;

  const Materi({
    required this.id,
    required this.nama,
    this.deskripsi,
    this.urlVideo,
    this.urlGambar,
    required this.urutan,
    this.isCompleted = false,
    this.isUnlocked = false,
    this.kategori,
  });

  factory Materi.fromJson(Map<String, dynamic> json) {
    return Materi(
      id: json['id'],
      nama: json['nama'],
      deskripsi: json['deskripsi'],
      urlVideo: json['url_video'],
      urlGambar: json['url_gambar'],
      urutan: json['urutan'] ?? 0,
      isCompleted: json['is_completed'] ?? false,
      isUnlocked: json['is_unlocked'] ?? false,
      kategori: json['kategori'] != null ? Kategori.fromJson(json['kategori']) : null,
    );
  }

  @override
  List<Object?> get props => [id, nama, deskripsi, urlVideo, urlGambar, isCompleted, isUnlocked];
}