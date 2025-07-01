import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'kategori_event.dart';
part 'kategori_state.dart';

class KategoriBloc extends Bloc<KategoriEvent, KategoriState> {
  KategoriBloc() : super(KategoriInitial()) {
    on<KategoriEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
