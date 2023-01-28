import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting/data/person/bloc/person_event.dart';
import 'package:meeting/data/person/bloc/person_state.dart';
import 'package:meeting/data/person/person.dart';
import 'package:meeting/data/user_event/bloc/user_event_bloc.dart';
import 'package:meeting/data/user_event/user_event.dart';
import 'package:meeting/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

ValueNotifier<String> userUid = ValueNotifier('');
ValueNotifier<String> usermail = ValueNotifier('');

class PersonBloc extends Bloc<PersonsEvent, PersonState> {
  static ValueNotifier<PersonState> personsState =
      ValueNotifier(PersonInitial());

  PersonBloc() : super(PersonInitial()) {
    _getUser();
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    on<PersonsStarted>((event, emit) async {
      ref.child(Constants.personsKey).onValue.listen((e) async {
        var value = e.snapshot.value;
        final data = value as Map?;
        List<Person> persons = data == null
            ? []
            : data.values
                .map((json) => Person.fromJson(Map<String, dynamic>.from(json)))
                // .where((element) => element.adminId == userUid.value)
                .toList()
          ..sort(((a, b) => b.date.compareTo(a.date)));

        personsState.value = PersonSucces(persons: persons);
      }, onError: (e) {
        personsState.value = PersonError(message: e.toString());
      });
    });

    on<PersonUpdate>((event, emit) async {
      try {
        Person newPerson = event.person;
        newPerson.adminId = userUid.value;
        if (newPerson.id == null) {
          var personsRef = ref.child(Constants.personsKey).push();
          String? id = personsRef.key;
          newPerson.id = id;
          await personsRef.set(newPerson.toJson());
        } else {
          await ref
              .child(Constants.personsKey)
              .child(newPerson.id!)
              .update(newPerson.toJson());
        }
      } on Exception catch (e) {
        emit(PersonError(message: e.toString()));
      }
    });

    on<PersonDelete>((event, emit) async {
      try {
        Person deletedPerson = event.person;
        await ref.child(Constants.personsKey).child(deletedPerson.id!).remove();

        List<UserEvent> userEvents =
            (UserEventBloc.userEventState.value as UserEventSucces).userevents;
        for (UserEvent userEvent in userEvents) {
          if (userEvent.userId == event.person.id) {
            var id = userEvent.eventId + userEvent.userId;
            await ref.child(Constants.personEventKey).child(id).remove();
          }
        }
      } on Exception catch (e) {
        emit(PersonError(message: e.toString()));
      }
    });
  }

  void _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString(Constants.userIdPrefsKey);
    String? userMail = prefs.getString(Constants.userMailPrefsKey);
    userUid.value = userId ?? '';
    usermail.value = userMail ?? '';
  }
}
