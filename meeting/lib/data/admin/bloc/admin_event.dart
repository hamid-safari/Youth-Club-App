part of 'admin_bloc.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object> get props => [];
}

class AdminStarted extends AdminEvent {
  final String email;
  final String password;
  const AdminStarted({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class AdminCreate extends AdminEvent {
  final String email;
  final String password;
  const AdminCreate({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}
