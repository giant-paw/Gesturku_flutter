part of 'edit_kategori_bloc.dart';

abstract class EditKategoriState extends Equatable {
  const EditKategoriState();

  @override
  List<Object> get props => [];
}

class EditKategoriInitial extends EditKategoriState {}

class EditKategoriLoading extends EditKategoriState {}

class EditKategoriSukses extends EditKategoriState {}

class EditKategoriError extends EditKategoriState {
  final String message;

  const EditKategoriError({required this.message});

  @override
  List<Object> get props => [message];
}
