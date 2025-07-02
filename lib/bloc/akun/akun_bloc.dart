import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'akun_event.dart';
part 'akun_state.dart';

class AkunBloc extends Bloc<AkunEvent, AkunState> {
  AkunBloc() : super(AkunInitial()) {
    on<AkunEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
