// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meeting/data/event/bloc/event_bloc.dart';
import 'package:meeting/data/event/event.dart';
import 'package:meeting/data/user_event/bloc/user_event_bloc.dart';
import 'package:meeting/data/user_event/bloc/user_event_event.dart';
import 'package:meeting/theme/app_color.dart';
import 'package:meeting/ui/screen/dashboard_details_screen.dart';
import 'package:meeting/ui/screen/history_list_screen.dart';
import 'package:meeting/ui/widget/empty_state.dart';
import 'package:meeting/utils/strings.dart';
import 'package:meeting/utils/utils.dart';
import 'package:page_transition/page_transition.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.home),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _openHistoryListScreen(context);
            },
            icon: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                  color: AppColor.surface,
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(Icons.history),
            ),
            splashRadius: 0.1,
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: EventBloc.eventState,
        builder: (context, state, child) {
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
            List<Event> events = state.events.toList();
            if (events.isEmpty) {
              return Container(
                color: AppColor.white,
                child: EmptyState(
                  image: SvgPicture.asset(
                    'assets/images/no_item.svg',
                    width: MediaQuery.of(context).size.width / 2,
                  ),
                  title: 'No Item',
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  itemCount: events.length,
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    return Container(
                      // padding: EdgeInsets.all(8),
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.black.withOpacity(0.1),
                            blurRadius: 10,
                          ),
                          // gradient: LinearGradient(
                          //   //   begin: Alignment.topLeft,
                          //   //   end: Alignment.bottomRight,
                          //   //   colors: [
                          //   //     AppColor.primaryLight,
                          //   //     AppColor.primary,
                          //   //     AppColor.primaryDark,
                          //   //   ],
                          //   // ),
                        ],
                      ),
                      child: Material(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            _openDashboardDetailsScreen(context, events[index]);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: FittedBox(
                              child: Text(
                                events[index].title,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(
                                      color: AppColor.primaryText,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }

  void _openDashboardDetailsScreen(BuildContext context, Event event) {
    context.read<UserEventBloc>().add(UserEventStarted(
        event: event, date: DateTime.now().millisecondsSinceEpoch));
    Navigator.of(context).push(
      transition(
        DashboardDetailsScreen(
          event: event,
        ),
        type: PageTransitionType.fade,
        duration: 200,
      ),
    );
  }

  void _openHistoryListScreen(BuildContext context) {
    context.read<UserEventBloc>().add(UserEventStarted(
        event: null, date: DateTime.now().millisecondsSinceEpoch));
    Navigator.of(context).push(transition(HistoryListScreen(),
        type: PageTransitionType.fade, duration: 100));
  }
}
