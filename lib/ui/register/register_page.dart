import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../bloc/auth/auth_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    super.dispose();
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
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else if (state is AuthUnauthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registrasi Gagal. Periksa kembali data Anda atau email mungkin sudah terdaftar.'),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Buat Akun Baru',
                      style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Satu langkah lagi untuk mulai belajar.',
                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 32),

                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: _imageFile != null ? FileImage(File(_imageFile!.path)) : null,
                          child: _imageFile == null ? Icon(Icons.person, size: 60, color: Colors.grey.shade500) : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: IconButton(
                              icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                              onPressed: _pickImage,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    TextFormField(controller: _namaController, decoration: InputDecoration(labelText: 'Nama Lengkap', prefixIcon: const Icon(Icons.person_outline), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), validator: (v) => v!.isEmpty ? 'Nama wajib diisi' : null),
                    const SizedBox(height: 16),
                    TextFormField(controller: _emailController, decoration: InputDecoration(labelText: 'Email', prefixIcon: const Icon(Icons.email_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), keyboardType: TextInputType.emailAddress, validator: (v) => v!.isEmpty ? 'Email wajib diisi' : null),
                    const SizedBox(height: 16),
                    TextFormField(controller: _passwordController, decoration: InputDecoration(labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline_rounded), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), suffixIcon: IconButton(icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible))), obscureText: !_isPasswordVisible, validator: (v) => v!.isEmpty ? 'Password wajib diisi' : null),
                    const SizedBox(height: 16),
                    TextFormField(controller: _passwordConfirmationController, decoration: InputDecoration(labelText: 'Konfirmasi Password', prefixIcon: const Icon(Icons.lock_person_rounded), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), suffixIcon: IconButton(icon: Icon(_isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible))), obscureText: !_isConfirmPasswordVisible, validator: (v) => v != _passwordController.text ? 'Password tidak cocok' : null),
                    const SizedBox(height: 32),

                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return const CircularProgressIndicator();
                        }
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: Colors.green[600], foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(RegisterButtonPressed(
                                      nama: _namaController.text,
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      passwordConfirmation: _passwordConfirmationController.text,
                                      fotoProfil: _imageFile,
                                    ));
                              }
                            },
                            child: Text('Daftar Akun', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
                          ),
                        );
                      },
                    ),

                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Sudah punya akun? Login', style: GoogleFonts.poppins(color: Colors.grey[700])),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}