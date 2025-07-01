import 'package:flutter/material.dart';
import '../../../models/materi.dart';

class MateriDetailPage extends StatefulWidget {
  // Halaman ini akan menerima satu objek Materi lengkap
  final Materi materi;

  const MateriDetailPage({super.key, required this.materi});

  @override
  State<MateriDetailPage> createState() => _MateriDetailPageState();
}

class _MateriDetailPageState extends State<MateriDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.materi.nama),
      ),
      body: const Center(
        child: Text('Video dan deskripsi akan muncul di sini'),
      ),
    );
  }
}