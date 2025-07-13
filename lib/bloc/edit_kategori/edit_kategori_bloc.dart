import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'edit_kategori_event.dart';
part 'edit_kategori_state.dart';

class EditKategoriBloc extends Bloc<EditKategoriEvent, EditKategoriState> {
  EditKategoriBloc() : super(EditKategoriInitial()) {
    on<EditKategoriEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
