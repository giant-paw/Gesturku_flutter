import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../bloc/edit_materi/edit_materi_bloc.dart';
import '../../../bloc/kategori/kategori_bloc.dart';
import '../../../models/kategori.dart';
import '../../../models/materi.dart';
import '../../../repositories/kategori_repository.dart';
import '../../../repositories/materi_repository.dart';

class EditMateriPage extends StatefulWidget {
  final Materi materiToEdit;
  const EditMateriPage({super.key, required this.materiToEdit});

  @override
  State<EditMateriPage> createState() => _EditMateriPageState();
}

class _EditMateriPageState extends State<EditMateriPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _deskripsiController;
  late TextEditingController _urutanController;
  int? _selectedKategoriId;
  XFile? _selectedFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.materiToEdit.nama);
    _deskripsiController = TextEditingController(text: widget.materiToEdit.deskripsi);
    _urutanController = TextEditingController(text: widget.materiToEdit.urutan.toString());
    _selectedKategoriId = widget.materiToEdit.kategori?.id;
  }

  Future<void> _pickFile() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() { _selectedFile = file; });
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => KategoriBloc(
            kategoriRepository: RepositoryProvider.of<KategoriRepository>(context),
          )..add(FetchKategori()),
        ),
        BlocProvider(
          create: (context) => EditMateriBloc(
            materiRepository: RepositoryProvider.of<MateriRepository>(context),
          ),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('Edit Materi')),
        body: BlocListener<EditMateriBloc, EditMateriState>(
          listener: (context, state) {
            if (state is EditMateriSukses) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Materi berhasil diperbarui!'), backgroundColor: Colors.green),
              );
              Navigator.of(context).pop(true); 
            } else if (state is EditMateriError) {
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
                  BlocBuilder<KategoriBloc, KategoriState>(
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
                  Text('Pilih file baru jika ingin mengganti file lama:', style: Theme.of(context).textTheme.bodySmall),
                  Row(
                    children: [
                      ElevatedButton.icon(onPressed: _pickFile, icon: const Icon(Icons.attach_file), label: const Text('Pilih File Baru')),
                      const SizedBox(width: 10),
                      Expanded(child: Text(_selectedFile?.name ?? 'Tidak ada file baru dipilih', overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                  const SizedBox(height: 32),

                  BlocBuilder<EditMateriBloc, EditMateriState>(
                    builder: (context, state) {
                      if (state is EditMateriLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: Colors.blue),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<EditMateriBloc>().add(SimpanPerubahanMateri(
                              materiId: widget.materiToEdit.id,
                              nama: _namaController.text,
                              kategoriId: _selectedKategoriId!,
                              deskripsi: _deskripsiController.text,
                              urutan: int.parse(_urutanController.text),
                              file: _selectedFile,
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