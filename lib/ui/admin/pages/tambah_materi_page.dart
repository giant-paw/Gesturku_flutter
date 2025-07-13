import 'package:flutter/material.dart';

class TambahMateriPage extends StatelessWidget {
  const TambahMateriPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Materi Baru'),
      ),
      body: const Center(
        child: Text('Form untuk menambah materi akan ada di sini.'),
      ),
    );
  }
}