import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../bloc/tambah_kategori/tambah_kategori_bloc.dart';
import '../../../repositories/kategori_repository.dart';

class TambahKategoriPage extends StatefulWidget {
  const TambahKategoriPage({super.key});

  @override
  State<TambahKategoriPage> createState() => _TambahKategoriPageState();
}

class _TambahKategoriPageState extends State<TambahKategoriPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _urutanController = TextEditingController();
  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _urutanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => TambahKategoriBloc(
            kategoriRepository: RepositoryProvider.of<KategoriRepository>(
              context,
            ),
          ),
      child: Scaffold(
        appBar: AppBar(title: const Text('Tambah Kategori Baru')),
        body: BlocListener<TambahKategoriBloc, TambahKategoriState>(
          listener: (context, state) {
            if (state is TambahKategoriSukses) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Kategori baru berhasil ditambahkan!'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).pop(true);
            } else if (state is TambahKategoriError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Gagal: ${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _namaController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Kategori',
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Nama tidak boleh kosong'
                                : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _deskripsiController,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _urutanController,
                    decoration: const InputDecoration(
                      labelText: 'Urutan',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Urutan tidak boleh kosong'
                                : null,
                  ),
                  const SizedBox(height: 24),

                  if (_selectedImage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Image.file(
                        File(_selectedImage!.path),
                        height: 150,
                      ),
                    ),

                  OutlinedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image_search),
                    label: Text(
                      _selectedImage == null
                          ? 'Pilih Gambar Kategori'
                          : 'Ganti Gambar',
                    ),
                  ),
                  const SizedBox(height: 32),

                  BlocBuilder<TambahKategoriBloc, TambahKategoriState>(
                    builder: (context, state) {
                      if (state is TambahKategoriLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<TambahKategoriBloc>().add(
                              SimpanKategoriBaru(
                                nama: _namaController.text,
                                deskripsi: _deskripsiController.text,
                                urutan: int.parse(_urutanController.text),
                                gambar: _selectedImage,
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.save),
                        label: const Text('Simpan Kategori'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
