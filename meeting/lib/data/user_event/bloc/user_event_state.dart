part of 'user_event_bloc.dart';

abstract class UserEventState extends Equatable {
  const UserEventState();

  @override
  List<Object> get props => [];
}

class UserEventInitial extends UserEventState {}

class UserEventLoading extends UserEventState {}

class UserEventError extends UserEventState {
  final String message;

  const UserEventError({required this.message});

  @override
  List<Object> get props => [message];
}

class UserEventSucces extends UserEventState {
  final List<UserEvent> userevents;
  final List<Person> persons;

  const UserEventSucces({
    required this.userevents,
    required this.persons,
  });

  @override
  List<Object> get props => [persons, userevents];
}
