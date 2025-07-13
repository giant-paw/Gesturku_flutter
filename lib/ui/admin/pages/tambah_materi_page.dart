import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../bloc/kategori/kategori_bloc.dart';
import '../../../bloc/tambah_materi/tambah_materi_bloc.dart';
import '../../../models/kategori.dart';
import '../../../repositories/kategori_repository.dart';
import '../../../repositories/materi_repository.dart';

class TambahMateriPage extends StatefulWidget {
  const TambahMateriPage({super.key});

  @override
  State<TambahMateriPage> createState() => _TambahMateriPageState();
}

class _TambahMateriPageState extends State<TambahMateriPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _urutanController = TextEditingController();
  int? _selectedKategoriId;
  XFile? _selectedFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _selectedFile = file;
      });
    }
  }
  
  Future<void> _pickVideo() async {
    final XFile? file = await _picker.pickVideo(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _selectedFile = file;
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
      create: (context) => TambahMateriBloc(
        materiRepository: RepositoryProvider.of<MateriRepository>(context),
      ),
      child: Scaffold(
        appBar: AppBar(title: const Text('Tambah Materi Baru')),
        body: BlocListener<TambahMateriBloc, TambahMateriState>(
          listener: (context, state) {
            if (state is TambahMateriSukses) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Materi baru berhasil ditambahkan!'), backgroundColor: Colors.green),
              );
              Navigator.of(context).pop(true); 
            } else if (state is TambahMateriError) {
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
                    decoration: const InputDecoration(labelText: 'Nama Materi'),
                    validator: (value) => value == null || value.isEmpty ? 'Nama tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 16),
                  
                  // Dropdown kategori sekarang butuh BlocProvider sendiri
                  BlocProvider(
                    create: (context) => KategoriBloc(
                      kategoriRepository: RepositoryProvider.of<KategoriRepository>(context),
                    )..add(FetchKategori()),
                    child: BlocBuilder<KategoriBloc, KategoriState>(
                      builder: (context, state) {
                        if (state is KategoriLoaded) {
                          return DropdownButtonFormField<int>(
                            value: _selectedKategoriId,
                            hint: const Text('Pilih Kategori'),
                            items: state.kategori.map((Kategori kategori) {
                              return DropdownMenuItem<int>(value: kategori.id, child: Text(kategori.nama));
                            }).toList(),
                            onChanged: (value) {
                              setState(() { _selectedKategoriId = value; });
                            },
                            validator: (value) => value == null ? 'Kategori harus dipilih' : null,
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _deskripsiController,
                    decoration: const InputDecoration(labelText: 'Deskripsi'),
                    maxLines: 4,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _urutanController,
                    decoration: const InputDecoration(labelText: 'Urutan'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || value.isEmpty ? 'Urutan tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 24),
                  
                  if (_selectedFile != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text('File terpilih: ${_selectedFile!.name}', style: const TextStyle(fontStyle: FontStyle.italic)),
                    ),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.image),
                        label: const Text('Pilih Gambar'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                      ),
                      ElevatedButton.icon(
                        onPressed: _pickVideo,
                        icon: const Icon(Icons.video_collection),
                        label: const Text('Pilih Video'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Tombol Simpan
                  BlocBuilder<TambahMateriBloc, TambahMateriState>(
                    builder: (context, state) {
                      if (state is TambahMateriLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: Colors.blue),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (_selectedFile == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('File video/gambar wajib dipilih!'), backgroundColor: Colors.red),
                                );
                                return;
                            }
                            context.read<TambahMateriBloc>().add(SimpanMateriBaru(
                              nama: _namaController.text,
                              kategoriId: _selectedKategoriId!,
                              deskripsi: _deskripsiController.text,
                              urutan: int.parse(_urutanController.text),
                              file: _selectedFile!,
                            ));
                          }
                        },
                        child: const Text('Simpan Materi', style: TextStyle(color: Colors.white)),
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