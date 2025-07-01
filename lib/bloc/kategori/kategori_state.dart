part of 'kategori_bloc.dart';

abstract class KategoriState extends Equatable {
  const KategoriState();
  
  @override
  List<Object> get props => [];
}

class KategoriInitial extends KategoriState {}

class KategoriLoading extends KategoriState {}

class KategoriLoaded extends KategoriState {
  final List<Kategori> kategori;

  const KategoriLoaded({required this.kategori});

  @override
  List<Object> get props => [kategori];
}

class KategoriError extends KategoriState {
  final String message;

  const KategoriError({required this.message});

  @override
  List<Object> get props => [message];
}