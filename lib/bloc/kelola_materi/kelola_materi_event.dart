part of 'kelola_materi_bloc.dart';

abstract class KelolaMateriEvent extends Equatable {
  const KelolaMateriEvent();
  @override
  List<Object> get props => [];
}

class FetchAllMateri extends KelolaMateriEvent {}
