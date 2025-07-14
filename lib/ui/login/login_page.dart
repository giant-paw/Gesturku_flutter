import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gesturku_app/ui/register/register_page.dart';
import 'package:google_fonts/google_fonts.dart'; 
import '../../bloc/auth/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], 
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            final currentState = context.read<AuthBloc>().state;
            if (currentState is! AuthLoading) {
               ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text('Login Gagal! Periksa kembali email dan password Anda.'),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
            }
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // --- Header ---
                    Icon(
                      Icons.waving_hand_rounded,
                      size: 80,
                      color: Colors.green[700],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Masuk untuk melanjutkan petualangan belajarmu.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // --- Form Input ---
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: !_isPasswordVisible,
                    ),
                    const SizedBox(height: 32),

                    if (state is AuthLoading)
                      const CircularProgressIndicator()
                    else
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.green[600],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            final authBloc = BlocProvider.of<AuthBloc>(context);
                            authBloc.add(
                              LoggedIn(
                                email: emailController.text.trim(),
                                password: passwordController.text,
                              ),
                            );
                          },
                          child: Text(
                            'Login',
                            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Belum punya akun?', style: GoogleFonts.poppins()),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const RegisterPage()),
                            );
                          },
                          child: Text(
                            'Daftar di sini',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.green[700]),
                          ),
                        ),
                      ],
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