import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../models/materi.dart';
import '../../../repositories/materi_repository.dart';

part 'kelola_materi_event.dart';
part 'kelola_materi_state.dart';

class KelolaMateriBloc extends Bloc<KelolaMateriEvent, KelolaMateriState> {
  final MateriRepository materiRepository;

  KelolaMateriBloc({required this.materiRepository})
    : super(KelolaMateriInitial()) {
    on<FetchAllMateri>(_onFetchAllMateri);
  }

  void _onFetchAllMateri(
    FetchAllMateri event,
    Emitter<KelolaMateriState> emit,
  ) async {
    emit(KelolaMateriLoading());
    try {
      final materiList = await materiRepository.fetchAllMateriForAdmin();
      emit(KelolaMateriLoaded(materi: materiList));
    } catch (e) {
      emit(KelolaMateriError(message: e.toString()));
    }
  }
}
