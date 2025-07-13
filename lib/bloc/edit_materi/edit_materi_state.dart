part of 'edit_materi_bloc.dart';

abstract class EditMateriState extends Equatable {
  const EditMateriState();
  @override
  List<Object> get props => [];
}

class EditMateriInitial extends EditMateriState {}

class EditMateriLoading extends EditMateriState {}

class EditMateriSukses extends EditMateriState {}

class EditMateriError extends EditMateriState {
  final String message;
  const EditMateriError({required this.message});
  @override
  List<Object> get props => [message];
}
