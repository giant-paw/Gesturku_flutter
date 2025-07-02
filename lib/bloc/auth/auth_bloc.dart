import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/pengguna.dart';
import '../../repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthUninitialized()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
    on<RegisterButtonPressed>(_onRegisterButtonPressed);
  }

  void _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final bool hasToken = await authRepository.hasToken();
    if (hasToken) {
      emit(AuthUnauthenticated());
    } else {
      emit(AuthUnauthenticated());
    }
  }

  void _onLoggedIn(LoggedIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await authRepository.login(event.email, event.password);
      final Pengguna pengguna = result['user'];
      emit(AuthAuthenticated(pengguna: pengguna));
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  void _onRegisterButtonPressed(RegisterButtonPressed event, Emitter<AuthState> emit) async {
  emit(AuthLoading());
  try {
    final result = await authRepository.register(
      nama: event.nama,
      email: event.email,
      password: event.password,
      passwordConfirmation: event.passwordConfirmation,
      fotoProfil: event.fotoProfil,
    );
    final Pengguna pengguna = result['user'];
    emit(AuthAuthenticated(pengguna: pengguna));
  } catch (e) {
    emit(AuthUnauthenticated()); 
  }
}

  void _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await authRepository.logout();
    emit(AuthUnauthenticated());
  }
}