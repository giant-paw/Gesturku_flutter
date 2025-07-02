part of 'deteksi_bloc.dart';

abstract class DeteksiState extends Equatable {
  const DeteksiState();
  @override
  List<Object> get props => [];
}

class DeteksiInitial extends DeteksiState {}
class DeteksiLoading extends DeteksiState {}

class DeteksiSukses extends DeteksiState {
  final String resultImageUrl;
  final String detectedClassName;

  const DeteksiSukses({
    required this.resultImageUrl,
    required this.detectedClassName,
  });

  @override
  List<Object> get props => [resultImageUrl, detectedClassName];
}

class DeteksiGagal extends DeteksiState {
  final String pesanError;
  const DeteksiGagal({required this.pesanError});
  @override
  List<Object> get props => [pesanError];
}