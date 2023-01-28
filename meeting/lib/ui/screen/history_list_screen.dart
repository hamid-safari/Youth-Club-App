// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:meeting/data/user_event/bloc/user_event_bloc.dart';
import 'package:meeting/data/user_event/user_event.dart';
import 'package:meeting/theme/app_color.dart';
import 'package:meeting/ui/screen/report_screen.dart';
import 'package:meeting/ui/widget/empty_state.dart';
import 'package:meeting/utils/strings.dart';
import 'package:meeting/utils/utils.dart';
import 'package:page_transition/page_transition.dart';

class HistoryListScreen extends StatelessWidget {
  const HistoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text(Strings.history),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          splashRadius: 20,
          icon: Icon(CupertinoIcons.back),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: UserEventBloc.userEventState,
        builder: (context, state, child) {
          Map<String, List<UserEvent>> items = {};
          // var items = [];
          if (state is UserEventSucces) {
            List<UserEvent> userEvents = state.userevents;

            items = groupBy(
              userEvents,
              (UserEvent userEvent) {
                String monthStr =
                    DateTime.fromMillisecondsSinceEpoch(userEvent.date)
                        .month
                        .toString()
                        .padLeft(2, '0');
                return '${DateTime.fromMillisecondsSinceEpoch(userEvent.date).year}$monthStr';
              },
            );
            items = Map.fromEntries(items.entries.toList()
              ..sort((e1, e2) => e2.key.compareTo(e1.key)));
            // userEvents.forEach((userEvent) {
            //   items.add(value);
            //  });
          }
          if (false) {
            return Expanded(
              child: EmptyState(
                image: SvgPicture.asset(
                  'assets/images/no_item.svg',
                  width: MediaQuery.of(context).size.width / 2,
                ),
                title: 'No Person',
              ),
            );
          } else {
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              itemCount: items.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                UserEvent userEvent =
                    items[items.entries.toList()[index].key]![0];
                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  child: Material(
                    color: AppColor.surface,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        _openReportScreen(
                            context, items, userEvent.date, index);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            // Icon(
                            //   Icons.calendar_month,
                            //   color: AppColor.divider,
                            // ),
                            // SizedBox(width: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  // radius: 24,
                                  backgroundColor: AppColor.secondary,
                                  child: Text(
                                    DateTime.fromMillisecondsSinceEpoch(
                                            userEvent.date)
                                        .year
                                        .toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.copyWith(
                                            fontWeight: FontWeight.w900,
                                            color: AppColor.white,
                                            fontSize: 14),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: AppColor.divider,
                                ),
                              ],
                            ),
                            Align(
                              child: Text(
                                DateFormat('MMMM').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        userEvent.date)),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.primaryText,
                                        fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _openReportScreen(BuildContext context,
      Map<String, List<UserEvent>> items, int date, int index) {
    Navigator.of(context).push(transition(
      type: PageTransitionType.fade,
      ReportScreen(
        userEvents: items.values.toList()[index],
        date: date,
      ),
    ));
  }
}
