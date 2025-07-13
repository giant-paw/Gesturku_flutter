import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import '../../../repositories/kategori_repository.dart';

part 'tambah_kategori_event.dart';
part 'tambah_kategori_state.dart';

class TambahKategoriBloc
    extends Bloc<TambahKategoriEvent, TambahKategoriState> {
  final KategoriRepository kategoriRepository;

  TambahKategoriBloc({required this.kategoriRepository})
    : super(TambahKategoriInitial()) {
    on<SimpanKategoriBaru>(_onSimpanKategori);
  }

  void _onSimpanKategori(
    SimpanKategoriBaru event,
    Emitter<TambahKategoriState> emit,
  ) async {
    emit(TambahKategoriLoading());
    try {
      await kategoriRepository.tambahKategori(
        nama: event.nama,
        deskripsi: event.deskripsi,
        urutan: event.urutan,
        gambar: event.gambar,
      );
      emit(TambahKategoriSukses());
    } catch (e) {
      emit(TambahKategoriError(message: e.toString()));
    }
  }
}
