import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '../../../bloc/deteksi/deteksi_bloc.dart';
import '../../../bloc/materi/materi_bloc.dart';
import '../../../bloc/riwayat_belajar/riwayat_belajar_bloc.dart';
import '../../../models/materi.dart';
import '../../../repositories/deteksi_repository.dart';
import '../../../repositories/riwayat_belajar_repository.dart';

class MateriDetailPage extends StatefulWidget {
  final Materi materi;
  const MateriDetailPage({super.key, required this.materi});

  @override
  State<MateriDetailPage> createState() => _MateriDetailPageState();
}

class _MateriDetailPageState extends State<MateriDetailPage> {
  VideoPlayerController? _controller;
  bool _isVideoInitialized = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    _controller?.dispose();
    _controller = null;
    _isVideoInitialized = false;

    if (widget.materi.urlVideo != null && widget.materi.urlVideo!.isNotEmpty) {
      final fileName = Uri.encodeComponent(widget.materi.urlVideo!);
      final videoUrl = 'http://10.0.2.2:8000/video-stream/$fileName';

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
  void didUpdateWidget(covariant MateriDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.materi.id != oldWidget.materi.id) {
      _initializeVideoPlayer();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _pickAndCheckImage(
    ImageSource source,
    BuildContext blocContext,
  ) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (image != null && blocContext.mounted) {
        blocContext.read<DeteksiBloc>().add(
              CekGambar(imageFile: image, materiYangDipelajari: widget.materi.nama),
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DeteksiBloc(
            deteksiRepository: RepositoryProvider.of<DeteksiRepository>(context),
          ),
        ),
        BlocProvider(
          create: (context) => RiwayatBelajarBloc(
            riwayatBelajarRepository: RepositoryProvider.of<RiwayatBelajarRepository>(context),
          ),
        ),
      ],
      child: Builder(
        builder: (blocContext) {
          return MultiBlocListener(
            listeners: [
              BlocListener<DeteksiBloc, DeteksiState>(
                listener: (context, state) async {
                  if (state is DeteksiSukses) {
                    final bool? inginLanjut = await showDialog<bool>(
                      context: context,
                      barrierDismissible: false,
                      builder: (dialogContext) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          title: const Row(children: [
                            Icon(Icons.check_circle, color: Colors.green),
                            SizedBox(width: 8),
                            Text('Kerja Bagus!'),
                          ]),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Gestur Anda terdeteksi sebagai "${state.detectedClassName}" dan sudah benar.'),
                                const SizedBox(height: 16),
                                if (state.resultImageBase64 != null)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.memory(base64Decode(state.resultImageBase64!))
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
                                Navigator.of(dialogContext).pop(true);
                              },
                            ),
                          ],
                        );
                      },
                    );

                    if (inginLanjut == true && context.mounted) {
                      context.read<RiwayatBelajarBloc>().add(
                            SimpanProgres(materiId: widget.materi.id),
                          );
                    }
                  } else if (state is DeteksiGagal) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal: ${state.pesanError}'), backgroundColor: Colors.red),
                    );
                  }
                },
              ),
              BlocListener<RiwayatBelajarBloc, RiwayatBelajarState>(
                listener: (context, state) {
                  if (state is RiwayatBelajarSukses) {
                    final materiState = context.read<MateriBloc>().state;
                    if (materiState is MateriLoaded) {
                      final daftarMateri = materiState.materi;
                      final indexSekarang = daftarMateri.indexWhere((m) => m.id == widget.materi.id);
                      if (indexSekarang != -1 && indexSekarang < daftarMateri.length - 1) {
                        final materiSelanjutnya = daftarMateri[indexSekarang + 1];
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: BlocProvider.of<MateriBloc>(context),
                              child: MateriDetailPage(materi: materiSelanjutnya),
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Selamat! Anda telah menyelesaikan kategori ini.'), backgroundColor: Colors.amber),
                        );
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      }
                    }
                  }
                },
              ),
            ],
            child: Scaffold(
              backgroundColor: const Color(0xFFF0F4F8), 
              appBar: AppBar(
                title: Text(widget.materi.nama),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                elevation: 1,
              ),
              body: SingleChildScrollView(
                child: Column(
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
                    else
                      Container(
                        height: 220,
                        color: Colors.black,
                        child: const Center(child: Icon(Icons.videocam_off, size: 60, color: Color.fromARGB(137, 255, 255, 255))),
                      ),
                    
                    if (_isVideoInitialized)
                      Container(
                        color: Colors.black.withOpacity(0.1),
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Center(
                          child: IconButton(
                            icon: Icon(_controller!.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled),
                            color: Colors.white,
                            iconSize: 48,
                            onPressed: () {
                              setState(() {
                                _controller!.value.isPlaying ? _controller!.pause() : _controller!.play();
                              });
                            },
                          ),
                        ),
                      ),

                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            widget.materi.nama,
                            style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.materi.deskripsi ?? 'Tidak ada deskripsi.',
                            style: GoogleFonts.lato(fontSize: 16, color: Colors.black87, height: 1.6),
                          ),
                          const SizedBox(height: 40),
                          
                          BlocBuilder<DeteksiBloc, DeteksiState>(
                            builder: (context, state) {
                              if (state is DeteksiLoading) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              return ElevatedButton.icon(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext bc) {
                                      return SafeArea(
                                        child: Wrap(children: <Widget>[
                                          ListTile(
                                            leading: const Icon(Icons.photo_library),
                                            title: const Text('Pilih dari Galeri'),
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              _pickAndCheckImage(ImageSource.gallery, blocContext);
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.photo_camera),
                                            title: const Text('Ambil dari Kamera'),
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              _pickAndCheckImage(ImageSource.camera, blocContext);
                                            },
                                          ),
                                        ]),
                                      );
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  backgroundColor: Theme.of(context).primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  textStyle: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                                ),
                                icon: const Icon(Icons.camera_alt_rounded),
                                label: const Text('Cek Gerakan'),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}