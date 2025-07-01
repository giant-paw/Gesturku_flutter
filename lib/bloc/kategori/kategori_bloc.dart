import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/kategori.dart';
import '../../repositories/kategori_repository.dart';

part 'kategori_event.dart';
part 'kategori_state.dart';

class KategoriBloc extends Bloc<KategoriEvent, KategoriState> {
  final KategoriRepository kategoriRepository;

  KategoriBloc({required this.kategoriRepository}) : super(KategoriInitial()) {
    on<FetchKategori>(_onFetchKategori);
  }

  void _onFetchKategori(FetchKategori event, Emitter<KategoriState> emit) async {
    emit(KategoriLoading());
    try {
      final List<Kategori> kategoriList = await kategoriRepository.fetchKategori();

      emit(KategoriLoaded(kategori: kategoriList));
    } catch (e) {
      emit(KategoriError(message: e.toString()));
    }
  }
}