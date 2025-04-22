import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchAccountsEvent extends HomeEvent {}

class DeleteAccountEvent extends HomeEvent {
  final int index;

  DeleteAccountEvent(this.index);

  @override
  List<Object?> get props => [index];
}