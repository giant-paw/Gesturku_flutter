import 'package:flutter/material.dart';

class MateriListPage extends StatelessWidget {
  final int kategoriId;
  final String kategoriNama;

  const MateriListPage({
    super.key,
    required this.kategoriId,
    required this.kategoriNama  
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kategoriNama),
      ),
      body: const Center(
        child: Text('Daftar materi akan muncul di sini'),
      ),
    );
  }
}