part of 'deteksi_bloc.dart';

abstract class DeteksiEvent extends Equatable {
  const DeteksiEvent();
  @override
  List<Object> get props => [];
}

class CekGambar extends DeteksiEvent {
  final XFile imageFile;
  final String materiYangDipelajari; // misal: 'Huruf A'

  const CekGambar({required this.imageFile, required this.materiYangDipelajari});
  @override
  List<Object> get props => [imageFile, materiYangDipelajari];
}