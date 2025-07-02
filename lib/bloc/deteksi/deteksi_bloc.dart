import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import '../../repositories/deteksi_repository.dart';

part 'deteksi_event.dart';
part 'deteksi_state.dart';

class DeteksiBloc extends Bloc<DeteksiEvent, DeteksiState> {
  final DeteksiRepository deteksiRepository;

  DeteksiBloc({required this.deteksiRepository}) : super(DeteksiInitial()) {
    on<CekGambar>(_onCekGambar);
  }

  void _onCekGambar(CekGambar event, Emitter<DeteksiState> emit) async {
  emit(DeteksiLoading());
  try {
    final hasil = await deteksiRepository.cekGambar(event.imageFile);

    if (hasil['detections'] != null && hasil['detections'].isNotEmpty) {
      String hurufTerdeteksi = hasil['detections'][0]['class_name'];

      if (hurufTerdeteksi.toLowerCase() == event.materiYangDipelajari.toLowerCase().replaceAll('huruf ', '')) {
        emit(DeteksiSukses(
          // Ambil data base64 dari JSON
          resultImageBase64: hasil['result_image_base64'],
          detectedClassName: hurufTerdeteksi,
        ));
      } else {
        emit(DeteksiGagal(pesanError: 'Gestur tidak sesuai. Terdeteksi: $hurufTerdeteksi'));
      }
    } else {
      emit(DeteksiGagal(pesanError: 'Tidak ada gestur yang terdeteksi.'));
    }
  } catch (e) {
    emit(DeteksiGagal(pesanError: e.toString()));
  }
}
}