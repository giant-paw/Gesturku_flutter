import 'package:equatable/equatable.dart';

class Pengguna extends Equatable {
  final String nama;
  final String email;
  final String role;

  const Pengguna({
    required this.nama,
    required this.email,
    required this.role,
  });

  factory Pengguna.fromJson(Map<String, dynamic> json) {
    return Pengguna(
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'userPembelajar',
    );
  }

  @override
  List<Object> get props => [nama, email, role];
}