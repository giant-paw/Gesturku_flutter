import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/materi.dart';
import '../../repositories/materi_repository.dart';

part 'materi_event.dart';
part 'materi_state.dart';

class MateriBloc extends Bloc<MateriEvent, MateriState> {
  final MateriRepository materiRepository;

  MateriBloc({required this.materiRepository}) : super(MateriInitial()) {
    on<FetchMateriByKategori>(_onFetchMateriByKategori);
  }

  void _onFetchMateriByKategori(
      FetchMateriByKategori event, Emitter<MateriState> emit) async {
    emit(MateriLoading());
    try {
      final materiList = await materiRepository.fetchMateriByKategori(event.kategoriId);
      emit(MateriLoaded(materi: materiList));
    } catch (e) {
      emit(MateriError(message: e.toString()));
    }
  }
}