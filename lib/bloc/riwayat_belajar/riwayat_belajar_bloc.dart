import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../repositories/riwayat_belajar_repository.dart';

part 'riwayat_belajar_event.dart';
part 'riwayat_belajar_state.dart';

class RiwayatBelajarBloc extends Bloc<RiwayatBelajarEvent, RiwayatBelajarState> {
  final RiwayatBelajarRepository riwayatBelajarRepository;

  RiwayatBelajarBloc({required this.riwayatBelajarRepository}) : super(RiwayatBelajarInitial()) {
    on<SimpanProgres>(_onSimpanProgres);
  }

  void _onSimpanProgres(SimpanProgres event, Emitter<RiwayatBelajarState> emit) async {
    emit(RiwayatBelajarLoading());
    try {
      await riwayatBelajarRepository.simpanProgres(event.materiId);
      emit(RiwayatBelajarSukses());
    } catch (e) {
      emit(RiwayatBelajarError(message: e.toString()));
    }
  }
}