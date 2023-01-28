part of 'admin_bloc.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object> get props => [];
}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminError extends AdminState {
  final String message;

  const AdminError({required this.message});

  @override
  List<Object> get props => [message];
}

class AdminSuccess extends AdminState {
  final Admin admin;

  const AdminSuccess({required this.admin});

  @override
  List<Object> get props => [admin];
}

class AdminCreated extends AdminState {}
