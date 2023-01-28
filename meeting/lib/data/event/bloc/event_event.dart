part of 'event_bloc.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object> get props => [];
}

class EventsStarted extends EventEvent {}

class EventUpdate extends EventEvent {
  final Event event;

  const EventUpdate(this.event);

  @override
  List<Object> get props => [event];
}

class EventDelete extends EventEvent {
  final Event event;

  const EventDelete(this.event);

  @override
  List<Object> get props => [event];
}
