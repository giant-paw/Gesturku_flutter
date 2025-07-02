part of 'deteksi_bloc.dart';

abstract class DeteksiState extends Equatable {
  const DeteksiState();
  @override
  List<Object> get props => [];
}

class DeteksiInitial extends DeteksiState {}
class DeteksiLoading extends DeteksiState {}

class DeteksiSukses extends DeteksiState {
  final String? resultImageBase64;
  final String detectedClassName;

  const DeteksiSukses({
    this.resultImageBase64,
    required this.detectedClassName,
  });

  @override
  List<Object> get props => [resultImageBase64 ?? '', detectedClassName];
}

class DeteksiGagal extends DeteksiState {
  final String pesanError;
  const DeteksiGagal({required this.pesanError});
  @override
  List<Object> get props => [pesanError];
}