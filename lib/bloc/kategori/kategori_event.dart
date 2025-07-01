part of 'kategori_bloc.dart';

abstract class KategoriEvent extends Equatable {
  const KategoriEvent();

  @override
  List<Object> get props => [];
}

class FetchKategori extends KategoriEvent{}
