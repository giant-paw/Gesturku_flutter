import 'package:flutter/material.dart';

class LearnerHomePage extends StatelessWidget {
  const LearnerHomePage({super.key});

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