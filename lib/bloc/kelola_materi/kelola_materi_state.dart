part of 'kelola_materi_bloc.dart';

abstract class KelolaMateriState extends Equatable {
  const KelolaMateriState();
  @override
  List<Object> get props => [];
}

class KelolaMateriInitial extends KelolaMateriState {}

class KelolaMateriLoading extends KelolaMateriState {}

class KelolaMateriLoaded extends KelolaMateriState {
  final List<Materi> materi;
  const KelolaMateriLoaded({required this.materi});
  @override
  List<Object> get props => [materi];
}

class KelolaMateriError extends KelolaMateriState {
  final String message;
  const KelolaMateriError({required this.message});
  @override
  List<Object> get props => [message];
}
