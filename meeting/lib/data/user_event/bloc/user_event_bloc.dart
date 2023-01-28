// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting/data/person/bloc/person_bloc.dart';
import 'package:meeting/data/person/bloc/person_state.dart';
import 'package:meeting/data/person/person.dart';
import 'package:meeting/data/user_event/bloc/user_event_event.dart';
import 'package:meeting/data/user_event/user_event.dart';
import 'package:meeting/utils/constants.dart';
import 'package:meeting/utils/utils.dart';

part 'user_event_state.dart';

class UserEventBloc extends Bloc<UserEventEvent, UserEventState> {
  static ValueNotifier<UserEventState> userEventState =
      ValueNotifier(UserEventInitial());

  UserEventBloc() : super(UserEventInitial()) {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    on<UserEventStarted>((event, emit) {
      ref.child(Constants.personEventKey).onValue.listen((e) async {
        var value = e.snapshot.value;
        final data = value as Map?;
        List<UserEvent> userEvents = data == null
            ? []
            : event.event?.id != null
                ? data.values
                    .map((json) =>
                        UserEvent.fromJson(Map<String, dynamic>.from(json)))
                    .where((element) =>
                        element.eventId == event.event!.id &&
                        isSameDate(event.date, element.date))
                    .toList()
                : data.values
                    .map((json) =>
                        UserEvent.fromJson(Map<String, dynamic>.from(json)))
                    .toList();

        List<Person> allPersons = [];
        if (PersonBloc.personsState.value is PersonSucces) {
          var persons = (PersonBloc.personsState.value as PersonSucces).persons;
          userEvents.forEachIndexed((index, userEvent) {
            Person? person = persons
                .firstWhereOrNull((person) => person.id == userEvent.userId);
            if (person != null) {
              person.userEventId = userEvents[index].id;
              allPersons.add(person);
            }
          });
        }

        userEventState.value = UserEventLoading();
        userEventState.value =
            UserEventSucces(persons: allPersons, userevents: userEvents);
      }, onError: (e) {
        userEventState.value = UserEventError(message: e.toString());
      });
    });

    on<UserEventAdd>((event, emit) async {
      try {
        UserEvent userEvent = event.userEvent;
        if ((userEventState.value as UserEventSucces)
            .userevents
            .map((e) => e.userId)
            .contains(userEvent.userId)) {
          return;
        }
        // if (userEvent.id == null) {
        //   var userEventRef = ref.child(Constants.userEventKey).push();
        //   String? id = userEventRef.key;
        //   userEvent.id = id;
        //   await userEventRef.set(userEvent.toJson());
        // } else {
        //   await ref
        //       .child(Constants.userEventKey)
        //       .child(userEvent.id!)
        //       .update(userEvent.toJson());
        // }

        // userEvent.id = userEvent.eventId + userEvent.userId;
        var userEventRef = ref.child(Constants.personEventKey).push();
        String? id = userEventRef.key;
        userEvent.id = id;
        // var userEventRef =
        //     ref.child(Constants.personEventKey).child(userEvent.id!);
        // var userEventRef = ref.child(Constants.personEventKey).push();
        // String? id = userEventRef.key;
        // userEvent.id = id;
        await userEventRef.set(userEvent.toJson());
      } on Exception catch (e) {
        emit(UserEventError(message: e.toString()));
      }
    });

    on<UserEventDelete>((event, emit) async {
      try {
        Person person = event.person;
        // Event selectedEvent = event.event;
        // var id = selectedEvent.id! + person.id!;
        await ref
            .child(Constants.personEventKey)
            .child(person.userEventId!)
            .remove();
      } on Exception catch (e) {
        emit(UserEventError(message: e.toString()));
      }
    });
  }
}
