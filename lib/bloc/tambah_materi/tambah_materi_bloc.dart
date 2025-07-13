import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import '../../../repositories/materi_repository.dart';

part 'tambah_materi_event.dart';
part 'tambah_materi_state.dart';

class TambahMateriBloc extends Bloc<TambahMateriEvent, TambahMateriState> {
  final MateriRepository materiRepository;

  TambahMateriBloc({required this.materiRepository}) : super(TambahMateriInitial()) {
    on<SimpanMateriBaru>(_onSimpanMateriBaru);
  }

  void _onSimpanMateriBaru(SimpanMateriBaru event, Emitter<TambahMateriState> emit) async {
    emit(TambahMateriLoading());
    try {
      await materiRepository.tambahMateriBaru(
        nama: event.nama,
        kategoriId: event.kategoriId,
        deskripsi: event.deskripsi,
        urutan: event.urutan,
        file: event.file,
      );
      emit(TambahMateriSukses());
    } catch (e) {
      emit(TambahMateriError(message: e.toString()));
    }
  }
}