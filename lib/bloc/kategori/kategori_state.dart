part of 'kategori_bloc.dart';

sealed class KategoriState extends Equatable {
  const KategoriState();
  
  @override
  List<Object> get props => [];
}

final class KategoriInitial extends KategoriState {}
