// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meeting/data/person/bloc/person_bloc.dart';
import 'package:meeting/data/person/bloc/person_event.dart';
import 'package:meeting/data/person/bloc/person_state.dart';
import 'package:meeting/data/person/person.dart';
import 'package:meeting/theme/app_color.dart';
import 'package:meeting/ui/dialog/confirm_dialog.dart';
import 'package:meeting/ui/screen/create_admin_screen.dart';
import 'package:meeting/ui/screen/person_screen.dart';
import 'package:meeting/ui/widget/empty_state.dart';
import 'package:meeting/ui/widget/searchview.dart';
import 'package:meeting/utils/strings.dart';
import 'package:meeting/utils/utils.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text(Strings.users),
        // title: ValueListenableBuilder<String>(
        //   valueListenable: usermail,
        //   builder: (context, email, child) {
        //     context.read<PersonBloc>().add(PersonsStarted());
        //     return Text(email);
        //   },
        // ),
        centerTitle: true,
        actions: [
          // IconButton(
          //   onPressed: () async {
          //     _openCreateAdminScreen(context);
          //   },
          //   icon: Icon(Icons.support),
          //   splashRadius: 20,
          // ),
          IconButton(
            onPressed: () async {
              // await FirebaseAuth.instance.signOut();
              // showDialog(
              //   context: context,
              //   builder: (context) {
              //     return Dialog(
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(12),
              //       ),
              //       child: Container(
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(12),
              //           color: AppColor.white,
              //         ),
              //         child: Padding(
              //           padding: const EdgeInsets.all(16),
              //           child: Column(
              //             mainAxisSize: MainAxisSize.min,
              //             children: [
              //               Text(
              //                 'Are you sure to Logot?',
              //                 style: Theme.of(context).textTheme.headline6,
              //               ),
              //               SizedBox(height: 32),
              //               Row(
              //                 children: [
              //                   Expanded(
              //                     child: OutlinedButton(
              //                       onPressed: () {
              //                         Navigator.of(context).pop();
              //                       },
              //                       child: Text('NO'),
              //                     ),
              //                   ),
              //                   SizedBox(width: 16),
              //                   Expanded(
              //                     child: ElevatedButton(
              //                       onPressed: () async {
              //                         Navigator.of(context).pop();
              //                         await FirebaseAuth.instance.signOut();
              //                       },
              //                       child: Text('Yes'),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     );
              //   },
              // );

              showDialog(
                context: context,
                builder: (context) {
                  return ConfirmDialog(
                    title: 'Are you sure want to LogOut?',
                    onSubmit: () async {
                      // Navigator.of(context).pop();
                      await FirebaseAuth.instance.signOut();
                    },
                  );
                },
              );
            },
            icon: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                  color: AppColor.surface,
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(Icons.logout),
            ),
            splashRadius: 0.1,
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 64),
        child: FloatingActionButton(
          heroTag: Strings.users,
          onPressed: () {
            _openUserScreen(context);
          },
          child: Icon(CupertinoIcons.person_add_solid),
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
                if (state is PersonInitial) {
                  context.read<PersonBloc>().add(PersonsStarted());
                  return SizedBox();
                } else if (state is PersonLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is PersonError) {
                  return Center(
                    child: Text(state.message),
                  );
                } else if (state is PersonSucces) {
                  List<Person> persons = state.persons
                      .where((person) => person.firstName
                          .toLowerCase()
                          .contains(_query.toLowerCase()))
                      .toList();
                  if (persons.isEmpty) {
                    return Expanded(
                      child: EmptyState(
                        image: SvgPicture.asset(
                          'assets/images/no_item.svg',
                          width: MediaQuery.of(context).size.width / 2,
                        ),
                        title: 'No Person',
                      ),
                    );
                  } else {}
                  return Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 120),
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: persons.length,
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
                          Person person = persons[index];
                          return PersonRow(
                            person: person,
                            onTap: () => _openUserScreen(context, person: person),
                          );
                        }
                      },
                    ),
                  );
                } else {
                  return SizedBox();
                }
              },
              valueListenable: PersonBloc.personsState,
            ),
          ],
        ),
      ),
    );
  }

  void _openUserScreen(BuildContext context, {Person? person}) {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context).push(transition(PersonScreen(
      person: person,
    )));
  }

  void _openCreateAdminScreen(BuildContext context) {
    Navigator.of(context).push(transition(CreateAdminSscreen()));
  }
}

class PersonRow extends StatelessWidget {
  final Function()? onTap;
  const PersonRow({
    Key? key,
    required this.person,
    this.onTap,
  }) : super(key: key);

  final Person person;

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
                  person.gender == Gender.male
                      ? Icons.man
                      : person.gender == Gender.female
                          ? Icons.woman
                          : Icons.person,
                  color: AppColor.divider,
                ),
                Expanded(
                  child: Text(
                    '${person.firstName} ${person.lastName}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      onTap?.call();
                    },
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColor.yellow.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.edit,
                        size: 20,
                        color: AppColor.yellow,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      //context.read<PersonBloc>().add(PersonDelete(person));
                      showDialog(
                        context: context,
                        builder: (context) {
                          return ConfirmDialog(
                            title: 'Are you sure want to delete?',
                            onSubmit: () {
                              context
                                  .read<PersonBloc>()
                                  .add(PersonDelete(person));
                            },
                          );
                        },
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
