import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '../../../bloc/deteksi/deteksi_bloc.dart';
import '../../../models/materi.dart';
import '../../../repositories/deteksi_repository.dart';

class MateriDetailPage extends StatelessWidget {
  final Materi materi;

  const MateriDetailPage({super.key, required this.materi});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeteksiBloc(
        deteksiRepository: RepositoryProvider.of<DeteksiRepository>(context),
      ),
      
      child: BlocListener<DeteksiBloc, DeteksiState>(
        listener: (context, state) {
          if (state is DeteksiSukses) {
            showDialog(
              context: context,
              barrierDismissible: false, 
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  title: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 8),
                      Text('Kerja Bagus!'),
                    ],
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Gestur Anda terdeteksi sebagai "${state.detectedClassName}" dan sudah benar.'),
                        const SizedBox(height: 16),
                        
                        if (state.resultImageBase64 != null)
                          Image.memory(
                            base64Decode(state.resultImageBase64!),
                          )
                        else
                          const Text('Tidak ada gambar hasil.'),
                      ],
                    ),
                  ),  
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Lanjut Belajar'),
                      onPressed: () {
                        Navigator.of(dialogContext).pop(); 
                      },
                    ),
                  ],
                );
              },
            );
          } else if (state is DeteksiGagal) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Gagal: ${state.pesanError}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: MateriDetailView(materi: materi),
      ),
    );
  }
}

class MateriDetailView extends StatefulWidget {
  final Materi materi;

  const MateriDetailView({super.key, required this.materi});

  @override
  State<MateriDetailView> createState() => _MateriDetailViewState();
}

class _MateriDetailViewState extends State<MateriDetailView> {
  VideoPlayerController? _controller;
  bool _isVideoInitialized = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.materi.urlVideo != null) {
      final videoUrl = 'http://10.0.2.2:8000/storage/${widget.materi.urlVideo}';
      _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              _isVideoInitialized = true;
            });
            _controller?.setLooping(true);
            _controller?.play();
          }
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _pickAndCheckImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source, imageQuality: 80);
      if (image != null && mounted) {
        context.read<DeteksiBloc>().add(
          CekGambar(
            imageFile: image,
            materiYangDipelajari: widget.materi.nama,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memilih gambar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.materi.nama),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.materi.urlVideo != null && _controller != null)
              _isVideoInitialized
                  ? AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    )
                  : const AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Center(child: CircularProgressIndicator()),
                    )
            else if (widget.materi.urlGambar != null)
              Image.network('http://10.0.2.2:8000/storage/${widget.materi.urlGambar}')
            else
              const AspectRatio(
                aspectRatio: 16 / 9,
                child: Center(child: Icon(Icons.videocam_off_rounded, size: 50, color: Colors.grey)),
              ),
            
            const SizedBox(height: 16),

            // Tombol Play/Pause
            if (_isVideoInitialized)
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _controller?.value.isPlaying ?? false
                        ? _controller?.pause()
                        : _controller?.play();
                  });
                },
                child: Icon(
                  _controller?.value.isPlaying ?? false ? Icons.pause : Icons.play_arrow,
                ),
              ),

            const SizedBox(height: 24),

            Text(
              widget.materi.nama,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.materi.deskripsi ?? 'Tidak ada deskripsi.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 40),

            BlocBuilder<DeteksiBloc, DeteksiState>(
              builder: (context, state) {
                if (state is DeteksiLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext bc) {
                        return SafeArea(
                          child: Wrap(
                            children: <Widget>[
                              ListTile(
                                  leading: const Icon(Icons.photo_library),
                                  title: const Text('Pilih dari Galeri'),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    _pickAndCheckImage(ImageSource.gallery);
                                  }),
                              ListTile(
                                leading: const Icon(Icons.photo_camera),
                                title: const Text('Ambil dari Kamera'),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  _pickAndCheckImage(ImageSource.camera);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Cek Gerakan'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}