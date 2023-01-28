import 'package:equatable/equatable.dart';
import 'package:meeting/data/event/event.dart';
import 'package:meeting/data/person/person.dart';
import 'package:meeting/data/user_event/user_event.dart';

abstract class UserEventEvent extends Equatable {
  const UserEventEvent();

  @override
  List<Object> get props => [];
}

class UserEventStarted extends UserEventEvent {
  final Event? event;
  final int date;

  const UserEventStarted({
    required this.event,
    required this.date,
  });

  // @override
  // List<Object> get props => [event];
}

class UserEventAdd extends UserEventEvent {
  final UserEvent userEvent;

  const UserEventAdd({required this.userEvent});

  @override
  List<Object> get props => [userEvent];
}

class UserEventDelete extends UserEventEvent {
  final Event event;
  final Person person;
  final DateTime date;

  const UserEventDelete({
    required this.event,
    required this.person,
    required this.date,
  });

  @override
  List<Object> get props => [Person];
}
