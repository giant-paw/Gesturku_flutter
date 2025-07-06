import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gesturku_app/bloc/auth/auth_bloc.dart';
import 'package:gesturku_app/models/pengguna.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilPage extends StatefulWidget {
  final Pengguna pengguna;
  const EditProfilPage({super.key, required this.pengguna});

  @override
  State<EditProfilPage> createState() => _EditProfilPageState();
}

class _EditProfilPageState extends State<EditProfilPage> {
  late final TextEditingController _namaController;
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.pengguna.nama);
  }

  Future<void> _pickImage() async {
    final XFile? selectedImage = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (selectedImage != null) {
      setState(() {
        _imageFile = selectedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPhotoPath = widget.pengguna.pathFotoProfil;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            InkWell(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _imageFile != null
                    ? FileImage(File(_imageFile!.path)) as ImageProvider
                    : (currentPhotoPath != null && currentPhotoPath.isNotEmpty
                        ? NetworkImage('http://10.0.2.2:8000/files/$currentPhotoPath')
                        : null),
                child: (_imageFile == null && (currentPhotoPath == null || currentPhotoPath.isEmpty))
                    ? const Icon(Icons.person, size: 60)
                    : null,
              ),
            ),
            const SizedBox(height: 8),
            const Text('Ubah Foto Profil'),
            const SizedBox(height: 24),
            TextField(controller: _namaController, decoration: const InputDecoration(labelText: 'Nama Lengkap')),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(UpdateProfil(
                  nama: _namaController.text,
                  fotoProfil: _imageFile,
                ));
                Navigator.of(context).pop(); 
              },
              child: const Text('Simpan Perubahan'),
            )
          ],
        ),
      ),
    );
  }
}