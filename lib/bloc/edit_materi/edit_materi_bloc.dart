import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import '../../../repositories/materi_repository.dart';

part 'edit_materi_event.dart';
part 'edit_materi_state.dart';

class EditMateriBloc extends Bloc<EditMateriEvent, EditMateriState> {
  final MateriRepository materiRepository;

  EditMateriBloc({required this.materiRepository})
    : super(EditMateriInitial()) {
    on<SimpanPerubahanMateri>(_onSimpanPerubahanMateri);
  }

  void _onSimpanPerubahanMateri(
    SimpanPerubahanMateri event,
    Emitter<EditMateriState> emit,
  ) async {
    emit(EditMateriLoading());
    try {
      await materiRepository.updateMateri(
        materiId: event.materiId,
        nama: event.nama,
        kategoriId: event.kategoriId,
        deskripsi: event.deskripsi,
        urutan: event.urutan,
        file: event.file,
      );
      emit(EditMateriSukses());
    } catch (e) {
      emit(EditMateriError(message: e.toString()));
    }
  }
}
