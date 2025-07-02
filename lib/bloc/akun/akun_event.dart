part of 'akun_bloc.dart';
abstract class AkunEvent extends Equatable {
  const AkunEvent();
  @override
  List<Object> get props => [];
}
class FetchAkunData extends AkunEvent {}