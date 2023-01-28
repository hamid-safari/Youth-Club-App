import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting/data/event/event.dart';
import 'package:meeting/utils/constants.dart';

import '../../person/bloc/person_bloc.dart';

part 'event_event.dart';
part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  static ValueNotifier<EventState> eventState = ValueNotifier(EventInitial());
  // String? userUid;

  EventBloc() : super(EventInitial()) {
    // _getUser();

    DatabaseReference ref = FirebaseDatabase.instance.ref();
    on<EventsStarted>((event, emit) async {
      ref.child(Constants.eventsKey).onValue.listen((e) async {
        var value = e.snapshot.value;
        final data = value as Map?;
        List<Event> events = data == null
            ? []
            : data.values
                .map((json) => Event.fromJson(Map<String, dynamic>.from(json)))
                // .where((element) => element.adminId == userUid.value)
                .toList()
          ..sort((a, b) {
            return b.date.compareTo(a.date);
          });

        eventState.value = EventSucces(events: events);
      }, onError: (e) {
        eventState.value = EventError(message: e.toString());
      });
    });

    on<EventUpdate>((event, emit) async {
      try {
        Event newEvent = event.event;
        newEvent.adminId = userUid.value;
        if (newEvent.id == null) {
          var eventsRef = ref.child(Constants.eventsKey).push();
          String? id = eventsRef.key;
          newEvent.id = id;
          await eventsRef.set(newEvent.toJson());
        } else {
          await ref
              .child(Constants.eventsKey)
              .child(newEvent.id!)
              .update(newEvent.toJson());
        }
      } on Exception catch (e) {
        emit(EventError(message: e.toString()));
      }
    });

    on<EventDelete>((event, emit) async {
      try {
        Event deletedEvent = event.event;
        await ref.child(Constants.eventsKey).child(deletedEvent.id!).remove();
      } on Exception catch (e) {
        emit(EventError(message: e.toString()));
      }
    });
  }

  // void _getUser() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? user = prefs.getString(Constants.userPrefsKey);
  //   userUid = user ?? '';
  //   debugPrint(user ?? '');
  // }
}
