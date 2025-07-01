import 'package:flutter/material.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Admin')),
      body: const Center(
        child: Text(
          'Selamat Datang, Admin!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}