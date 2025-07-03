import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../repositories/auth_repository.dart';

part 'akun_event.dart';
part 'akun_state.dart';

class AkunBloc extends Bloc<AkunEvent, AkunState> {
  final AuthRepository authRepository;
  AkunBloc({required this.authRepository}) : super(AkunInitial()) {
    on<FetchAkunData>((event, emit) async {
      emit(AkunLoading());
      try {
        final count = await authRepository.getRingkasanProgres();
        emit(AkunLoaded(totalSelesai: count));
      } catch (e) {
        emit(AkunError(message: e.toString()));
      }
    });
  }
}
