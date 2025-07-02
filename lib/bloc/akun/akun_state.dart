part of 'akun_bloc.dart';

sealed class AkunState extends Equatable {
  const AkunState();
  
  @override
  List<Object> get props => [];
}

final class AkunInitial extends AkunState {}
