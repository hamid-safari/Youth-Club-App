// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:horizontal_data_table/horizontal_data_table.dart';
// import 'package:meeting/data/event/bloc/event_bloc.dart';
// import 'package:meeting/data/person/bloc/person_bloc.dart';
// import 'package:meeting/data/person/bloc/person_event.dart';
// import 'package:meeting/data/person/bloc/person_state.dart';
// import 'package:meeting/data/person/person.dart';
// import 'package:meeting/data/user_event/bloc/user_event_bloc.dart';
// import 'package:meeting/data/user_event/bloc/user_event_event.dart';
// import 'package:meeting/data/user_event/user_event.dart';
// import 'package:meeting/theme/app_color.dart';
// import 'package:meeting/ui/screen/history_list_screen.dart';
// import 'package:meeting/utils/constants.dart';
// import 'package:meeting/utils/strings.dart';
// import 'package:meeting/utils/utils.dart';
// import 'package:page_transition/page_transition.dart';

// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(getCurrentDate()),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             onPressed: () {
//               _openHistoryListScreen(context);
//             },
//             icon: Icon(Icons.history),
//             splashRadius: 20,
//           ),
//         ],
//       ),
//       body: ValueListenableBuilder(
//         valueListenable: PersonBloc.personsState,
//         builder: (context, usersState, child) {
//           if (usersState is PersonInitial) {
//             context.read<PersonBloc>().add(PersonsStarted());
//             return SizedBox();
//           } else if (usersState is PersonSucces) {
//             List<Person> users = usersState.persons;
//             return ValueListenableBuilder(
//               valueListenable: EventBloc.eventState,
//               builder: (context, eventState, child) {
//                 if (eventState is EventInitial) {
//                   context.read<EventBloc>().add(EventsStarted());
//                   return SizedBox();
//                 } else if (eventState is EventSucces) {
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 0),
//                           child: HorizontalDataTable(
//                             // horizontalScrollPhysics: BouncingScrollPhysics(),
//                             scrollPhysics: BouncingScrollPhysics(),
//                             leftHandSideColumnWidth: 100,
//                             rightHandSideColumnWidth:
//                                 MediaQuery.of(context).size.width + 10,

//                             // rightSideChildren: [],
//                             // leftSideChildren: [],
//                             isFixedHeader: true,

//                             rowSeparatorWidget: Divider(
//                                 // color: Colors.red,
//                                 ),
//                             elevation: 4,
//                             // elevationColor: Colors.black,
//                             // leftHandSideColBackgroundColor: Colors.blue,
//                             // rightHandSideColBackgroundColor: Colors.purple,
//                             headerWidgets: [
//                               Container(
//                                 width: Constants.cellWidth,
//                                 height: Constants.cellHeight,
//                                 alignment: Alignment.center,
//                                 child: Text(
//                                   Strings.user,
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .bodyText1
//                                       ?.copyWith(
//                                         color: AppColor.secondaryText,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                 ),
//                               ),

//                               ...eventState.events.map((e) {
//                                 return Container(
//                                   width: Constants.cellWidth,
//                                   height: Constants.cellHeight,
//                                   alignment: Alignment.center,
//                                   child: Text(
//                                     e.title,
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .bodyText1
//                                         ?.copyWith(
//                                           color: AppColor.secondaryText,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                   ),
//                                 );
//                               }).toList()

//                               // return Row(
//                               //   children: events,
//                               // );

//                               // ValueListenableBuilder(
//                               //   valueListenable: EventBloc.eventState,
//                               //   builder: (context, state, child) {
//                               //     if (state is EventInitial) {
//                               //       context.read<EventBloc>().add(EventsStarted());
//                               //       return SizedBox();
//                               //     } else if (state is EventSucces) {
//                               //       var events = state.events.map((e) {
//                               //         return Container(
//                               //           width: Constants.cellWidth,
//                               //           height: Constants.cellHeight,
//                               //           alignment: Alignment.center,
//                               //           child: Text(
//                               //             e.title,
//                               //             style: Theme.of(context)
//                               //                 .textTheme
//                               //                 .bodyText1
//                               //                 ?.copyWith(
//                               //                   color: AppColor.secondaryText,
//                               //                   fontWeight: FontWeight.bold,
//                               //                 ),
//                               //           ),
//                               //         );
//                               //       }).toList();

//                               //       return Row(
//                               //         children: events,
//                               //       );
//                               //     } else {
//                               //       return SizedBox();
//                               //     }
//                               //   },
//                               // ),
//                             ],

//                             rightSideItemBuilder: (context, index) {
//                               return ValueListenableBuilder(
//                                 valueListenable: UserEventBloc.userEventState,
//                                 builder: (context, state, child) {
//                                   if (state is UserEventInitial) {
//                                     context
//                                         .read<UserEventBloc>()
//                                         .add(UserEventStarted());
//                                     return SizedBox();
//                                   } else if (state is UserEventError) {
//                                     return Center(
//                                       child: Text(state.message),
//                                     );
//                                   } else if (state is UserEventSucces) {
//                                     List<UserEvent> userEvents =
//                                         state.userEvents;

//                                     return Row(
//                                       children: eventState.events
//                                           .map(
//                                             (event) => Container(
//                                               width: Constants.cellWidth,
//                                               height: Constants.cellHeight,
//                                               alignment: Alignment.center,
//                                               // padding: EdgeInsets.all(6),
//                                               // color: AppColor.red,
//                                               child: CellCheckBox(
//                                                 id: userEvents
//                                                         .where((userEvent) {
//                                                   return userEvent.userId ==
//                                                           users[index].id &&
//                                                       userEvent.eventId ==
//                                                           event.id &&
//                                                       isToday(userEvent.date);
//                                                 }).isEmpty
//                                                     ? null
//                                                     : userEvents
//                                                         .where((userEvent) {
//                                                           return userEvent
//                                                                       .userId ==
//                                                                   users[index]
//                                                                       .id &&
//                                                               userEvent
//                                                                       .eventId ==
//                                                                   event.id &&
//                                                               isToday(userEvent
//                                                                   .date);
//                                                         })
//                                                         .first
//                                                         .id,
//                                                 eventId: event.id,
//                                                 userId: users[index].id,
//                                                 isChecked: userEvents
//                                                     .where((userEvent) {
//                                                       return userEvent.userId ==
//                                                               users[index].id &&
//                                                           userEvent.eventId ==
//                                                               event.id &&
//                                                           isToday(
//                                                               userEvent.date);
//                                                     })
//                                                     .toList()
//                                                     .isNotEmpty,
//                                               ),
//                                             ),
//                                           )
//                                           .toList(),
//                                     );
//                                   } else {
//                                     return SizedBox();
//                                   }
//                                 },
//                               );
//                             },

//                             itemCount: users.length,
//                             leftSideItemBuilder: (context, index) {
//                               return Container(
//                                 width: Constants.cellWidth,
//                                 height: Constants.cellHeight,
//                                 alignment: Alignment.center,
//                                 child: Padding(
//                                   padding:
//                                       const EdgeInsets.symmetric(horizontal: 8),
//                                   child: FittedBox(
//                                     child: Text(
//                                       users[index].firstName,
//                                       // textAlign: TextAlign.center,
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .bodyText1
//                                           ?.copyWith(
//                                             color: AppColor.secondaryText,
//                                             // fontWeight: FontWeight.bold,
//                                           ),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                             // leftSideItemBuilder: (context, index) {
//                             //   return ValueListenableBuilder(
//                             //     valueListenable: UserBloc.usersState,
//                             //     builder: (context, state, child) {
//                             //       if (state is UserInitial) {
//                             //         context.read<UserBloc>().add(UsersStarted());
//                             //         return SizedBox();
//                             //       } else if (state is UserSucces) {
//                             //         List<User> users = state.users;
//                             //         return Container(
//                             //           width: Constants.cellWidth,
//                             //           height: Constants.cellHeight,
//                             //           alignment: Alignment.center,
//                             //           // padding: EdgeInsets.all(6),
//                             //           // color: AppColor.red,
//                             //           child: Text(
//                             //             users[index].firstName,
//                             //             // textAlign: TextAlign.center,
//                             //             style:
//                             //                 Theme.of(context).textTheme.bodyText1?.copyWith(
//                             //                       color: AppColor.primaryText,
//                             //                       fontWeight: FontWeight.bold,
//                             //                     ),
//                             //           ),
//                             //         );
//                             //       }
//                             //       return SizedBox();
//                             //     },
//                             //   );
//                             // },
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 } else {
//                   return SizedBox();
//                 }
//               },
//             );
//           } else {
//             return SizedBox();
//           }
//         },
//       ),
//     );
//   }

//   void _openHistoryListScreen(BuildContext context) {
//     Navigator.of(context).push(transition(HistoryListScreen(),
//         type: PageTransitionType.fade, duration: 100));
//   }
// }

// class CellCheckBox extends StatefulWidget {
//   String? id;
//   final String? eventId;
//   final String? userId;
//   final bool isChecked;

//   CellCheckBox({
//     Key? key,
//     this.id,
//     this.eventId,
//     this.userId,
//     required this.isChecked,
//   }) : super(key: key);

//   @override
//   State<CellCheckBox> createState() => _CellCheckBoxState();
// }

// class _CellCheckBoxState extends State<CellCheckBox> {
//   // bool _isChecked = false;
//   @override
//   Widget build(BuildContext context) {
//     return Transform.scale(
//       scale: 1.2,
//       child: Checkbox(
//         shape: CircleBorder(),
//         fillColor: MaterialStateProperty.all(AppColor.secondary),
//         onChanged: (bool? value) {
//           // showSnackbar(context, widget.userId ?? '');
//           // setState(() {
//           //   _isChecked = !_isChecked;
//           // });
//           UserEvent userEvent = UserEvent(
//             id: widget.id,
//             userId: widget.userId!,
//             eventId: widget.eventId!,
//             date: DateTime.now().millisecondsSinceEpoch,
//           );
//           if (widget.isChecked) {
//             context
//                 .read<UserEventBloc>()
//                 .add(UserEventDelete(userEvent: userEvent));
//           } else {
//             context
//                 .read<UserEventBloc>()
//                 .add(UserEventAdd(userEvent: userEvent));
//           }
//         },
//         value: widget.isChecked,
//       ),
//     );
//   }
// }
