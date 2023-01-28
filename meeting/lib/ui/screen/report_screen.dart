import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';
import 'package:meeting/data/event/bloc/event_bloc.dart';
import 'package:meeting/data/event/event.dart';
import 'package:meeting/data/person/bloc/person_bloc.dart';
import 'package:meeting/data/person/bloc/person_state.dart';
import 'package:meeting/data/person/person.dart';
import 'package:meeting/data/user_event/user_event.dart';
import 'package:meeting/theme/app_color.dart';
import 'package:meeting/utils/constants.dart';
import 'package:meeting/utils/strings.dart';
import 'package:meeting/utils/utils.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ReportScreen extends StatelessWidget {
  final List<UserEvent> userEvents;
  final int date;
  const ReportScreen({
    super.key,
    required this.userEvents,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle? headerStyle = Theme.of(context).textTheme.bodyText1?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColor.white,
        );

    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat('MMMM')
            .format(DateTime.fromMillisecondsSinceEpoch(date))),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          splashRadius: 20,
          icon: const Icon(CupertinoIcons.back),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              // DateTime dateTime = calcDate(date: date, index: index);
              // List<String> usersId = userEvents
              //     .where((element) =>
              //         element.eventId == event.id &&
              //         isSameDate(element.date, dateTime.millisecondsSinceEpoch))
              //     .map((e) => e.userId)
              //     .toList();

              // List<Person> persons =
              //     (PersonBloc.personsState.value as PersonSucces)
              //         .persons
              //         .where((element) => usersId.contains(element.id))
              //         .toList();
              pw.Document pdf = await _createPdf(context, date);
              await saveAndOpenDocument(pdf);
            },
            icon: SvgPicture.asset(
              'assets/images/ic_pdf.svg',
              width: 24,
              height: 24,
            ),
            splashRadius: 20,
          ),
        ],
      ),
      body: HorizontalDataTable(
        scrollPhysics: const BouncingScrollPhysics(),
        leftHandSideColumnWidth: Constants.cellWidth,
        rightHandSideColumnWidth:
            ((EventBloc.eventState.value as EventSucces).events.length + 2) *
                Constants.cellWidth,
        rowSeparatorWidget: const Divider(
          height: 0,
          color: AppColor.divider,
        ),
        isFixedHeader: true,
        elevation: 2,
        headerWidgets: [
          Container(
            color: AppColor.divider,
            width: Constants.cellWidth,
            height: Constants.cellHeight,
            alignment: Alignment.center,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Week',
                    textAlign: TextAlign.center,
                    style: headerStyle,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Tag',
                    textAlign: TextAlign.center,
                    style: headerStyle,
                  ),
                ),
              ],
            ),
          ),
          //  Container(
          //   color: AppColor.divider,
          //   width: Constants.cellWidth,
          //   height: Constants.cellHeight,
          //   alignment: Alignment.center,
          //   child: Text(
          //     'Day',
          //     style: headerStyle,
          //   ),
          // ),
          Row(
            children: (EventBloc.eventState.value as EventSucces)
                .events
                .map((e) => Container(
                      color: AppColor.divider,
                      width: Constants.cellWidth,
                      height: Constants.cellHeight,
                      alignment: Alignment.center,
                      child: FittedBox(
                        child: Text(
                          e.title,
                          style: headerStyle,
                        ),
                      ),
                    ))
                .toList(),
          ),
          Container(
            color: AppColor.divider,
            width: Constants.cellWidth / 2,
            height: Constants.cellHeight,
            alignment: Alignment.center,
            child: Text(
              'M',
              style: headerStyle,
            ),
          ),
          Container(
            color: AppColor.divider,
            width: Constants.cellWidth / 2,
            height: Constants.cellHeight,
            alignment: Alignment.center,
            child: Text(
              'F',
              style: headerStyle,
            ),
          ),
          Container(
            color: AppColor.divider,
            width: Constants.cellWidth / 2,
            height: Constants.cellHeight,
            alignment: Alignment.center,
            child: Text(
              'D',
              style: headerStyle,
            ),
          ),
          Container(
            color: AppColor.divider,
            width: Constants.cellWidth / 2,
            height: Constants.cellHeight,
            alignment: Alignment.center,
            child: Text(
              Strings.total,
              style: headerStyle,
            ),
          ),
          // Container(
          //   color: AppColor.divider,
          //   width: Constants.cellWidth,
          //   height: Constants.cellHeight,
          //   alignment: Alignment.center,
          //   child: Text(
          //     Strings.file,
          //     style: headerStyle,
          //   ),
          // ),
        ],
        leftSideItemBuilder: (context, index) {
          return Row(
            children: [
              Container(
                color: AppColor.surface,
                width: Constants.cellWidth / 2,
                height: Constants.cellHeight,
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: FittedBox(
                    child: Text(
                      DateFormat('EE')
                          .format(calcDate(date: date, index: index)),
                      // textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ),
              ),
              Container(
                color: AppColor.surface,
                width: Constants.cellWidth / 2,
                height: Constants.cellHeight,
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: FittedBox(
                    child: Text(
                      DateFormat('dd')
                          .format(calcDate(date: date, index: index)),
                      // textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        rightSideItemBuilder: (context, index) {
          List<Person> users = calcTotalUsers(
              userEvents: userEvents,
              index: index,
              events: (EventBloc.eventState.value as EventSucces).events);

          List<Person> males =
              users.where((element) => element.gender == Gender.male).toList();
          List<Person> females = users
              .where((element) => element.gender == Gender.female)
              .toList();
          List<Person> diverses = users
              .where((element) => element.gender == Gender.diverse)
              .toList();

          return Row(
              children: (EventBloc.eventState.value as EventSucces)
                  .events
                  .map((event) {
            // List<Person> males = users
            //     .where((element) => element.userEventId == event.id)
            //     .toList();
            int count = calcUsersOfEvent(
              userEvents: userEvents,
              event: event,
              index: index,
              users: users,
            );
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                // DateTime dateTime = calcDate(date: date, index: index);
                // List<String> usersId = userEvents
                //     .where((element) =>
                //         element.eventId == event.id &&
                //         isSameDate(
                //             element.date, dateTime.millisecondsSinceEpoch))
                //     .map((e) => e.userId)
                //     .toList();

                // List<Person> persons =
                //     (PersonBloc.personsState.value as PersonSucces)
                //         .persons
                //         .where((element) => usersId.contains(element.id))
                //         .toList();

                // pw.Document pdf =
                //     await _createPdf(context, persons, event, dateTime);
                // await saveAndOpenDocument(pdf);
              },
              child: Container(
                width: Constants.cellWidth,
                height: Constants.cellHeight,
                alignment: Alignment.center,
                // padding: EdgeInsets.all(6),
                // color: AppColor.red,
                child: Text(
                  '$count',
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        color: count > 0
                            ? AppColor.primaryText
                            : AppColor.secondaryText,
                        // fontWeight:
                        //     count > 0 ? FontWeight.bold : FontWeight.w400,
                      ),
                ),
              ),
            );
          }).toList()
                ..add(
                  GestureDetector(
                    child: Container(
                      width: Constants.cellWidth / 2,
                      height: Constants.cellHeight,
                      alignment: Alignment.center,
                      child: Text(
                        males.length.toString(),
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                              // fontWeight: FontWeight.bold,
                              color: users.isNotEmpty
                                  ? AppColor.primaryText
                                  : AppColor.secondaryText,
                            ),
                      ),
                    ),
                  ),
                )
                ..add(
                  GestureDetector(
                    child: Container(
                      width: Constants.cellWidth / 2,
                      height: Constants.cellHeight,
                      alignment: Alignment.center,
                      child: Text(
                        females.length.toString(),
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                              // fontWeight: FontWeight.bold,
                              color: users.isNotEmpty
                                  ? AppColor.primaryText
                                  : AppColor.secondaryText,
                            ),
                      ),
                    ),
                  ),
                )
                ..add(
                  GestureDetector(
                    child: Container(
                      width: Constants.cellWidth / 2,
                      height: Constants.cellHeight,
                      alignment: Alignment.center,
                      child: Text(
                        diverses.length.toString(),
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                              // fontWeight: FontWeight.bold,
                              color: users.isNotEmpty
                                  ? AppColor.primaryText
                                  : AppColor.secondaryText,
                            ),
                      ),
                    ),
                  ),
                )
                ..add(
                  GestureDetector(
                    child: Container(
                      width: Constants.cellWidth / 2,
                      height: Constants.cellHeight,
                      alignment: Alignment.center,
                      child: Text(
                        users.length.toString(),
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                              // fontWeight: FontWeight.bold,
                              color: users.isNotEmpty
                                  ? AppColor.primaryText
                                  : AppColor.secondaryText,
                            ),
                      ),
                    ),
                  ),
                )
              // ..add(GestureDetector(
              //   behavior: HitTestBehavior.translucent,
              //   onTap: () async {
              //     // showSnackbar(context, 'Download');

              //     DateTime dateTime = calcDate(date: date, index: index);

              //     List<Event> events =
              //         (EventBloc.eventState.value as EventSucces).events;

              //     List<List<Person>> allPersons = [];

              //     for (Event event in events) {
              //       List<String> usersId = userEvents
              //           .where((element) =>
              //               element.eventId == event.id &&
              //               isSameDate(
              //                   element.date, dateTime.millisecondsSinceEpoch))
              //           .map((e) => e.userId)
              //           .toList();

              //       List<Person> persons =
              //           (PersonBloc.personsState.value as PersonSucces)
              //               .persons
              //               .where((element) => usersId.contains(element.id))
              //               .toList();

              //       allPersons.add(persons);
              //     }

              //     pw.Document pdf =
              //         await _createPdf(context, allPersons, events, dateTime);

              //     await saveAndOpenDocument(pdf);
              //   },
              //   child: Container(
              //     width: Constants.cellWidth,
              //     height: Constants.cellHeight,
              //     alignment: Alignment.center,
              //     child: SvgPicture.asset(
              //       'assets/images/ic_pdf.svg',
              //       height: Constants.cellHeight * .6,
              //     ),
              //   ),
              // )),
              );
        },
        itemCount: calcDaysOfMonth(date: date),
      ),
    );
  }

  saveAndOpenDocument(pw.Document pdf) async {
    final output = await getApplicationDocumentsDirectory();
    final file = File("${output.path}/example.pdf");
    await file.writeAsBytes(await pdf.save());
    await OpenFilex.open(file.path);
  }

  int calcDaysOfMonth({required int date}) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    DateTime lastDate = DateTime.utc(dateTime.year, dateTime.month + 1, 0);
    return lastDate.day;
  }

  DateTime calcDate({required int date, required int index}) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    DateTime newDate = DateTime.utc(dateTime.year, dateTime.month, 1 + index);
    return newDate;
  }

  int calcUsersOfEvent({
    required List<UserEvent> userEvents,
    required Event event,
    required int index,
    required List<Person> users,
  }) {
    int sum = userEvents
        .where((element) =>
            (element.eventId == event.id) &&
            users.map((e) => e.id).contains(element.userId) &&
            isSameDate(element.date,
                calcDate(date: date, index: index).millisecondsSinceEpoch))
        .length;

    return sum;
  }

  List<Person> calcTotalUsers(
      {required List<UserEvent> userEvents,
      required int index,
      required List<Event> events}) {
    // int sum = userEvents
    //     .where((element) =>
    //         isSameDate(element.date,
    //             calcDate(date: date, index: index).millisecondsSinceEpoch) &&
    //         events.map((e) => e.id).contains(element.eventId))
    //     .length;

    DateTime dateTime = calcDate(date: date, index: index);
    List<Event> events = (EventBloc.eventState.value as EventSucces).events;
    List<List<Person>> allPersons = [];

    for (Event event in events) {
      List<String> usersId = userEvents
          .where((element) =>
              element.eventId == event.id &&
              isSameDate(element.date, dateTime.millisecondsSinceEpoch))
          .map((e) => e.userId)
          .toList();

      List<Person> persons = (PersonBloc.personsState.value as PersonSucces)
          .persons
          .where((element) => usersId.contains(element.id))
          .toList();

      allPersons.add(persons);
    }

    return allPersons.reduce((value, element) => value + element);
  }

  Future<pw.Document> _createPdf(BuildContext context, int date) async {
    List<int> days =
        List.generate(calcDaysOfMonth(date: date) + 1, (index) => index);
    List<Event> events = (EventBloc.eventState.value as EventSucces).events;

    String monthName =
        DateFormat('MMMM').format(DateTime.fromMillisecondsSinceEpoch(date));
    String year =
        DateFormat('yyyy').format(DateTime.fromMillisecondsSinceEpoch(date));

    final pdf = pw.Document();
    pw.Widget page1Widget = pw.Container(
        // padding: const pw.EdgeInsets.all(16),
        // decoration: pw.BoxDecoration(
        //   border: pw.Border.all(
        //     color: PdfColor.fromHex('#000000'),
        //     width: 2,
        //   ),
        //   borderRadius: pw.BorderRadius.circular(8),
        // ),
        child: pw.Container(
      child: pw.Column(
        // mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.Text('$monthName $year',
              style: pw.TextStyle(
                fontSize: 18,
                color: PdfColor.fromInt(AppColor.primaryText.value),
              )),
          pw.SizedBox(height: 16),
          ...days
              .asMap()
              .map((index, e) {
                List<Person> users = calcTotalUsers(
                    userEvents: userEvents,
                    index: index - 1,
                    events: (EventBloc.eventState.value as EventSucces).events);

                List<Person> males = users
                    .where((element) => element.gender == Gender.male)
                    .toList();
                List<Person> females = users
                    .where((element) => element.gender == Gender.female)
                    .toList();
                List<Person> diverses = users
                    .where((element) => element.gender == Gender.diverse)
                    .toList();
                return MapEntry(
                  index,
                  pw.Expanded(
                      child: pw.Container(
                    // margin: pw.EdgeInsets.symmetric(vertical: 2),
                    color:
                        PdfColor.fromHex(index.isOdd ? '#FFFFFF' : '#F0F0F0'),
                    child: pw.Row(
                      // crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Expanded(
                            child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                if (index == 0)
                                  pw.Text('Week',
                                      textAlign: pw.TextAlign.center)
                                else
                                  pw.Text(
                                      DateFormat('EE').format(calcDate(
                                          date: date, index: index - 1)),
                                      textAlign: pw.TextAlign.center),
                              ],
                            ),
                            flex: 1),
                        pw.Expanded(
                            child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                if (index == 0)
                                  pw.Text('Tag', textAlign: pw.TextAlign.center)
                                else
                                  pw.Text(
                                      DateFormat('dd').format(calcDate(
                                          date: date, index: index - 1)),
                                      textAlign: pw.TextAlign.center),
                              ],
                            ),
                            flex: 1),
                        ...events
                            .map((event) => pw.Expanded(
                                child: pw.Column(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.center,
                                  children: [
                                    if (index == 0)
                                      pw.FittedBox(
                                        child: pw.Text(event.title,
                                            textAlign: pw.TextAlign.center),
                                      )
                                    else
                                      pw.Text(
                                          calcUsersOfEvent(
                                                      userEvents: userEvents,
                                                      event: event,
                                                      index: index - 1,
                                                      users: users) ==
                                                  0
                                              ? ''
                                              : calcUsersOfEvent(
                                                      userEvents: userEvents,
                                                      event: event,
                                                      index: index - 1,
                                                      users: users)
                                                  .toString(),
                                          textAlign: pw.TextAlign.center),
                                  ],
                                ),
                                flex: 2))
                            .toList(),
                        pw.Expanded(
                            child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                if (index == 0)
                                  pw.Text('M', textAlign: pw.TextAlign.center)
                                else
                                  pw.Text('${males.length}',
                                      textAlign: pw.TextAlign.center),
                              ],
                            ),
                            flex: 1),
                        pw.Expanded(
                            child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                if (index == 0)
                                  pw.Text('F', textAlign: pw.TextAlign.center)
                                else
                                  pw.Text('${females.length}',
                                      textAlign: pw.TextAlign.center),
                              ],
                            ),
                            flex: 1),
                        pw.Expanded(
                            child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                if (index == 0)
                                  pw.Text('D', textAlign: pw.TextAlign.center)
                                else
                                  pw.Text('${diverses.length}',
                                      textAlign: pw.TextAlign.center),
                              ],
                            ),
                            flex: 1),
                        pw.Expanded(
                            child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                if (index == 0)
                                  pw.Text('All', textAlign: pw.TextAlign.center)
                                else
                                  pw.Text('${users.length}',
                                      textAlign: pw.TextAlign.center),
                              ],
                            ),
                            flex: 1),
                      ],
                    ),
                  )),
                );
              })
              .values
              .toList()
        ],
      ),
    ));
    pw.Page page = pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) => page1Widget,
    );

    pdf.addPage(page); // Page
    return pdf;

    // for (int i = 0; i < events.length; i++) {
    //   if (allPersons[i].isEmpty) continue;
    //   pw.Widget page1Widget = pw.Container(
    //       alignment: pw.Alignment.center,
    //       width: MediaQuery.of(context).size.width,
    //       padding: const pw.EdgeInsets.all(16),
    //       decoration: pw.BoxDecoration(
    //         border: pw.Border.all(
    //           color: PdfColor.fromHex('#000000'),
    //           width: 2,
    //         ),
    //         borderRadius: pw.BorderRadius.circular(8),
    //       ),
    //       // color: const PdfColor.fromInt(200),
    //       child: pw.Column(
    //         crossAxisAlignment: pw.CrossAxisAlignment.center,
    //         children: [
    //           pw.Text(Strings.appName,
    //               style: pw.TextStyle(
    //                 fontWeight: pw.FontWeight.bold,
    //                 fontSize: 16,
    //               )),
    //           pw.Align(
    //             alignment: pw.Alignment.centerLeft,
    //             child: pw.Text(DateFormat('yyyy/MM/dd').format(dateTime),
    //                 style: pw.TextStyle(
    //                   color: PdfColor.fromHex('#757575'),
    //                 )),
    //           ),
    //           pw.SizedBox(height: 16),
    //           pw.Text(events[i].title),
    //           pw.SizedBox(height: 16),
    //           pw.Expanded(
    //             child: pw.ListView.separated(
    //               itemBuilder: (context, index) {
    //                 return pw.Row(
    //                   children: [
    //                     pw.Text(
    //                       '${index + 1}',
    //                       style: pw.TextStyle(
    //                         color: PdfColor.fromHex('#757575'),
    //                       ),
    //                     ),
    //                     pw.SizedBox(width: 12),
    //                     pw.Text(
    //                         '${allPersons[i][index].firstName} ${allPersons[i][index].lastName}')
    //                   ],
    //                 );
    //               },
    //               itemCount: allPersons[i].length,
    //               separatorBuilder: (context, index) {
    //                 return pw.Divider(
    //                   color: PdfColor.fromHex('#cccccc'),
    //                   thickness: 0.7,
    //                 );
    //               },
    //             ),
    //           ),
    //           pw.SizedBox(height: 16),
    //         ],
    //       ));

    //   pw.Page page = pw.Page(
    //     pageFormat: PdfPageFormat.a4,
    //     build: (context) => page1Widget,
    //   );

    //   pdf.addPage(page); // Page
    // }

    // return pdf;
  }
}
