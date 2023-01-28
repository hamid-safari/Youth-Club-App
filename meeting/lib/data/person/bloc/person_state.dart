import 'package:equatable/equatable.dart';
import 'package:meeting/data/person/person.dart';

abstract class PersonState extends Equatable {
  const PersonState();

  @override
  List<Object> get props => [];
}

class PersonInitial extends PersonState {}

class PersonLoading extends PersonState {}

class PersonUpdated extends PersonState {}

class PersonError extends PersonState {
  final String message;

  const PersonError({required this.message});

  @override
  List<Object> get props => [message];
}

class PersonSucces extends PersonState {
  final List<Person> persons;

  const PersonSucces({required this.persons});

  @override
  List<Object> get props => [persons];
}
