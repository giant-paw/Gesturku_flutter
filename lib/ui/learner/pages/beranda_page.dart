import 'package:flutter/material.dart';

class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selamat Belajar!')),
      body: const Center(
        child: Text(
          'Selamat Datang, Pembelajar!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}