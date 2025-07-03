part of 'akun_bloc.dart';

abstract class AkunState extends Equatable {
  const AkunState();
  @override
  List<Object> get props => [];
}

class AkunInitial extends AkunState {}

class AkunLoading extends AkunState {}

class AkunLoaded extends AkunState {
  final int totalSelesai;
  const AkunLoaded({required this.totalSelesai});
  @override
  List<Object> get props => [totalSelesai];
}

class AkunError extends AkunState {
  final String message;
  const AkunError({required this.message});
  @override
  List<Object> get props => [message];
}
