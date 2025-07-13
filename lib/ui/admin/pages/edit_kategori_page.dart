import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../bloc/edit_kategori/edit_kategori_bloc.dart';
import '../../../models/kategori.dart';
import '../../../repositories/kategori_repository.dart';

class EditKategoriPage extends StatefulWidget {
  final Kategori kategoriToEdit;

  const EditKategoriPage({super.key, required this.kategoriToEdit});

  @override
  State<EditKategoriPage> createState() => _EditKategoriPageState();
}

class _EditKategoriPageState extends State<EditKategoriPage> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _namaController;
  late TextEditingController _deskripsiController;
  late TextEditingController _urutanController;

  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.kategoriToEdit.nama);
    _deskripsiController = TextEditingController(text: widget.kategoriToEdit.deskripsi);
    _urutanController = TextEditingController(text: widget.kategoriToEdit.urutan.toString());
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
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
      create: (context) => EditKategoriBloc(
        kategoriRepository: RepositoryProvider.of<KategoriRepository>(context),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Kategori'),
        ),
        body: BlocListener<EditKategoriBloc, EditKategoriState>(
          listener: (context, state) {
            if (state is EditKategoriSukses) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Kategori berhasil diperbarui!'), backgroundColor: Colors.green),
              );
              Navigator.of(context).pop(true);
            } else if (state is EditKategoriError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}'), backgroundColor: Colors.red),
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
                    decoration: const InputDecoration(labelText: 'Nama Kategori'),
                    validator: (value) => value == null || value.isEmpty ? 'Nama tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _deskripsiController,
                    decoration: const InputDecoration(labelText: 'Deskripsi'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _urutanController,
                    decoration: const InputDecoration(labelText: 'Urutan'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || value.isEmpty ? 'Urutan tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 24),
                  
                  Text('Pilih gambar baru jika ingin mengganti:', style: Theme.of(context).textTheme.bodySmall),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.image),
                        label: const Text('Pilih Gambar'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _selectedImage?.name ?? 'Tidak ada gambar baru',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  BlocBuilder<EditKategoriBloc, EditKategoriState>(
                    builder: (context, state) {
                      if (state is EditKategoriLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.blue
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<EditKategoriBloc>().add(SimpanPerubahanKategori(
                              kategoriId: widget.kategoriToEdit.id,
                              nama: _namaController.text,
                              deskripsi: _deskripsiController.text,
                              urutan: int.parse(_urutanController.text),
                              gambar: _selectedImage, 
                            ));
                          }
                        },
                        child: const Text('Simpan Perubahan', style: TextStyle(color: Colors.white)),
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