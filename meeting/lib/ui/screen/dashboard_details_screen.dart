// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting/data/event/event.dart';
import 'package:meeting/data/person/bloc/person_bloc.dart';
import 'package:meeting/data/person/bloc/person_state.dart';
import 'package:meeting/data/person/person.dart';
import 'package:meeting/data/user_event/bloc/user_event_bloc.dart';
import 'package:meeting/data/user_event/bloc/user_event_event.dart';
import 'package:meeting/data/user_event/user_event.dart';
import 'package:meeting/theme/app_color.dart';
import 'package:meeting/ui/widget/custom_search_delegate.dart';
import 'package:meeting/utils/utils.dart';

class DashboardDetailsScreen extends StatelessWidget {
  DateTime selectedDate = DateTime.now();
  final Event event;
  DashboardDetailsScreen({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: PersonBloc.personsState,
      builder: (context, state, child) {
        if (state is PersonLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is PersonError) {
          return Center(
            child: Text(state.message),
          );
        } else if (state is PersonSucces) {
          return Scaffold(
            appBar: AppBar(
              title: Text(event.title),
              titleSpacing: 0,
              actions: [
                IconButton(
                  onPressed: () async {
                    var person = await showSearch<Person?>(
                      context: context,
                      delegate: CustomDelegate(persons: state.persons),
                    );
                    if (person == null) {
                      return;
                    }

                    context.read<UserEventBloc>().add(UserEventAdd(
                            userEvent: UserEvent(
                          userId: person.id!,
                          eventId: event.id!,
                          date: selectedDate.millisecondsSinceEpoch,
                        )));
                  },
                  icon: Icon(Icons.search),
                ),
              ],
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                splashRadius: 20,
                icon: Icon(CupertinoIcons.back),
              ),
              // elevation: 1,
            ),
            body: ValueListenableBuilder(
              valueListenable: UserEventBloc.userEventState,
              builder: (context, state, child) {
                if (state is UserEventLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is UserEventError) {
                  return Center(
                    child: Text(state.message),
                  );
                } else if (state is UserEventSucces) {
                  List<Person> persons = state.persons;
                  return ListView.builder(
                    padding: EdgeInsets.all(8),
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: persons.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColor.primary.withOpacity(0.2),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 8),
                                Material(
                                  color: AppColor.primary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(32),
                                  child: IconButton(
                                    onPressed: () {
                                      _loadPreviousDayData(context);
                                    },
                                    icon: Icon(
                                      Icons.arrow_back,
                                      color: AppColor.primary,
                                    ),
                                    splashRadius: 16,
                                    constraints: BoxConstraints(),
                                    padding: EdgeInsets.all(4),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    formatDate(selectedDate),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        ?.copyWith(
                                          color: AppColor.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                Material(
                                  color: AppColor.primary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(32),
                                  child: IconButton(
                                    onPressed: () {
                                      _loadNextDayData(context);
                                    },
                                    icon: Icon(
                                      Icons.arrow_forward,
                                      color: AppColor.primary,
                                    ),
                                    splashRadius: 16,
                                    constraints: BoxConstraints(),
                                    padding: EdgeInsets.all(4),
                                  ),
                                ),
                                SizedBox(width: 8),
                              ],
                            ));
                      } else {
                        return Container(
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: AppColor.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.black.withOpacity(0.1),
                                  blurRadius: 10,
                                ),
                              ]),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${persons[index - 1].firstName} ${persons[index - 1].lastName}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.copyWith(
                                        color: AppColor.primaryText,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () {
                                    context
                                        .read<UserEventBloc>()
                                        .add(UserEventDelete(
                                          event: event,
                                          person: persons[index - 1],
                                          date: selectedDate,
                                        ));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: AppColor.red.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.delete,
                                      size: 20,
                                      color: AppColor.red,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }

  _loadNextDayData(BuildContext context) {
    DateTime newDate = selectedDate.add(Duration(days: 1));
    selectedDate = newDate;
    context.read<UserEventBloc>().add(
        UserEventStarted(event: event, date: newDate.millisecondsSinceEpoch));
  }

  _loadPreviousDayData(BuildContext context) {
    DateTime newDate = selectedDate.subtract(Duration(days: 1));
    selectedDate = newDate;
    context.read<UserEventBloc>().add(
        UserEventStarted(event: event, date: newDate.millisecondsSinceEpoch));
  }
}
