part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

// Event jika login dipencet
class LoggedIn extends AuthEvent {
  final String email;
  final String password;

  const LoggedIn({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class RegisterButtonPressed extends AuthEvent {
  final String nama;
  final String email;
  final String password;
  final String passwordConfirmation;
  final XFile? fotoProfil;

  const RegisterButtonPressed({
    required this.nama,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    this.fotoProfil,
  });
}


// Event logout di pencet
class LoggedOut extends AuthEvent{}