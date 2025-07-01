import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gesturku_app/models/pengguna.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
