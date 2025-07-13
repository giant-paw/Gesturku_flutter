part of 'tambah_kategori_bloc.dart';

abstract class TambahKategoriState extends Equatable {
  const TambahKategoriState();

  @override
  List<Object> get props => [];
}

class TambahKategoriInitial extends TambahKategoriState {}

class TambahKategoriLoading extends TambahKategoriState {}

class TambahKategoriSukses extends TambahKategoriState {}

class TambahKategoriError extends TambahKategoriState {
  final String message;

  const TambahKategoriError({required this.message});

  @override
  List<Object> get props => [message];
}
