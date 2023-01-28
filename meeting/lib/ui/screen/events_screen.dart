// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meeting/data/event/bloc/event_bloc.dart';
import 'package:meeting/data/event/event.dart';
import 'package:meeting/theme/app_color.dart';
import 'package:meeting/ui/dialog/confirm_dialog.dart';
import 'package:meeting/ui/dialog/create_event_dialog.dart';
import 'package:meeting/ui/widget/empty_state.dart';
import 'package:meeting/ui/widget/searchview.dart';
import 'package:meeting/utils/strings.dart';
import 'package:provider/provider.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text(Strings.events),
        centerTitle: true,
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 64),
        child: FloatingActionButton(
          heroTag: Strings.events,
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            showEventDialog();
          },
          child: Icon(Icons.event_available),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SearchView(
              onChnage: (value) {
                _query = value;
                setState(() {});
              },
            ),
            SizedBox(height: 16),
            ValueListenableBuilder(
              builder: (BuildContext context, state, Widget? child) {
                if (state is EventInitial) {
                  context.read<EventBloc>().add(EventsStarted());
                  return SizedBox();
                } else if (state is EventLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is EventError) {
                  return Center(
                    child: Text(state.message),
                  );
                } else if (state is EventSucces) {
                  List<Event> events = state.events
                      .where((event) => event.title
                          .toLowerCase()
                          .contains(_query.toLowerCase()))
                      .toList();

                  if (events.isEmpty) {
                    return Expanded(
                      child: EmptyState(
                        image: SvgPicture.asset(
                          'assets/images/no_item.svg',
                          width: MediaQuery.of(context).size.width / 2,
                        ),
                        title: 'No Event',
                      ),
                    );
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        // padding: EdgeInsets.only(
                        //     left: 24, top: 16, right: 24, bottom: 120),
                        padding: EdgeInsets.only(bottom: 120),
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          if (false) {
                            return Column(
                              children: [
                                SearchView(
                                  onChnage: (value) {
                                    _query = value;
                                    setState(() {});
                                  },
                                ),
                                SizedBox(height: 16),
                              ],
                            );
                          } else {
                            Event event = events[index];
                            return EventRow(
                              event: event,
                              onTap: () {
                                debugPrint(event.title);
                                FocusManager.instance.primaryFocus?.unfocus();
                                showEventDialog(event: event);
                              },
                            );
                          }
                        },
                      ),
                    );
                  }
                } else {
                  return SizedBox();
                }
              },
              valueListenable: EventBloc.eventState,
            ),
          ],
        ),
      ),
    );
  }

  void showEventDialog({Event? event}) {
    showDialog(
      context: context,
      builder: (context) {
        return CreateEventDialog(
          event: event,
          onTap: (title) {
            // if (title.isEmpty) {
            //   showSnackbar(context, 'Please enter event name!');
            //   return;
            // }
            Event newEvent;
            if (event != null) {
              newEvent = event;
              newEvent.title = title;
            } else {
              newEvent = Event(
                  title: title, date: DateTime.now().millisecondsSinceEpoch);
            }
            context.read<EventBloc>().add(EventUpdate(newEvent));
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}

class EventRow extends StatelessWidget {
  final Function()? onTap;
  const EventRow({
    Key? key,
    required this.event,
    this.onTap,
  }) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onTap?.call(),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.event,
                  color: AppColor.divider,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    event.title,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => ConfirmDialog(
                          title: 'Are you sure want to delete?',
                          onSubmit: () {
                            context.read<EventBloc>().add(EventDelete(event));
                          },
                        ),
                      );
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
          ),
        ),
      ),
    );
  }
}
