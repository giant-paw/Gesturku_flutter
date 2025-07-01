part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object> get props => [];
}

// belum terotentikasi
class AuthUninitialized extends AuthState{}

// sukses otenti
class AuthAuthenticated extends AuthState{
  final Pengguna pengguna;

  const AuthAuthenticated({required this.pengguna});

  @override
  List<Object> get props => [pengguna];
}

// Tidak otenti (setelah logout atau gagal)
class AuthUnauthenticated extends AuthState{}

// saat loading (proses login)
class AuthLoading extends AuthState{}
