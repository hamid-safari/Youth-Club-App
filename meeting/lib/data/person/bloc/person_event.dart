import 'package:equatable/equatable.dart';
import 'package:meeting/data/person/person.dart';

abstract class PersonsEvent extends Equatable {
  const PersonsEvent();

  @override
  List<Object> get props => [];
}

class PersonsStarted extends PersonsEvent {}

class PersonUpdate extends PersonsEvent {
  final Person person;

  const PersonUpdate(this.person);

  @override
  List<Object> get props => [person];
}

class PersonDelete extends PersonsEvent {
  final Person person;

  const PersonDelete(this.person);

  @override
  List<Object> get props => [person];
}
