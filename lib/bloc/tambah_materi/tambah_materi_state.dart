part of 'tambah_materi_bloc.dart';

abstract class TambahMateriState extends Equatable {
  const TambahMateriState();
  @override
  List<Object> get props => [];
}

class TambahMateriInitial extends TambahMateriState {}
class TambahMateriLoading extends TambahMateriState {}
class TambahMateriSukses extends TambahMateriState {}
class TambahMateriError extends TambahMateriState {
  final String message;
  const TambahMateriError({required this.message});
  @override
  List<Object> get props => [message];
}