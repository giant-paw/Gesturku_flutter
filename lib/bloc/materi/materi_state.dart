part of 'materi_bloc.dart';

abstract class MateriState extends Equatable {
  const MateriState();
  @override
  List<Object> get props => [];
}

class MateriInitial extends MateriState {}
class MateriLoading extends MateriState {}

class MateriLoaded extends MateriState {
  final List<Materi> materi;
  const MateriLoaded({required this.materi});
  @override
  List<Object> get props => [materi];
}

class MateriError extends MateriState {
  final String message;
  const MateriError({required this.message});
  @override
  List<Object> get props => [message];
}