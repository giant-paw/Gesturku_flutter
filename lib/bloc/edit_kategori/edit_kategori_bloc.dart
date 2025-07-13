import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import '../../../repositories/kategori_repository.dart';

part 'edit_kategori_event.dart';
part 'edit_kategori_state.dart';

class EditKategoriBloc extends Bloc<EditKategoriEvent, EditKategoriState> {
  final KategoriRepository kategoriRepository;

  EditKategoriBloc({required this.kategoriRepository})
    : super(EditKategoriInitial()) {
    on<SimpanPerubahanKategori>(_onSimpanPerubahan);
  }

  void _onSimpanPerubahan(
    SimpanPerubahanKategori event,
    Emitter<EditKategoriState> emit,
  ) async {
    emit(EditKategoriLoading());
    try {
      await kategoriRepository.updateKategori(
        kategoriId: event.kategoriId,
        nama: event.nama,
        deskripsi: event.deskripsi,
        urutan: event.urutan,
        gambar: event.gambar,
      );
      emit(EditKategoriSukses());
    } catch (e) {
      emit(EditKategoriError(message: e.toString()));
    }
  }
}
