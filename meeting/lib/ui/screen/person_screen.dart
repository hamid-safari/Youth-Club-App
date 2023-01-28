// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, avoid_function_literals_in_foreach_calls

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meeting/data/person/bloc/person_bloc.dart';
import 'package:meeting/data/person/bloc/person_event.dart';
import 'package:meeting/data/person/person.dart';
import 'package:meeting/theme/app_color.dart';
import 'package:meeting/ui/widget/app_drop_down.dart';
import 'package:meeting/utils/strings.dart';
import 'package:meeting/utils/utils.dart';

class PersonScreen extends StatefulWidget {
  Person? person;
  PersonScreen({super.key, this.person});

  @override
  State<PersonScreen> createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
  List<TextEditingController> _controllers = [];
  FocusNode? phoneFocusNode;
  late Gender _selectedGender;
  DateTime? selectedDate;

  @override
  void initState() {
    String birthDate = '';
    if (widget.person?.birthDate != null) {
      selectedDate =
          DateTime.fromMillisecondsSinceEpoch(widget.person!.birthDate!);
      birthDate = DateFormat('yyyy/MM/dd').format(selectedDate!);
    }

    _controllers = [
      TextEditingController(text: widget.person?.firstName ?? ''),
      TextEditingController(text: widget.person?.lastName ?? ''),
      TextEditingController(text: birthDate),
      TextEditingController(text: widget.person?.school ?? ''),
      TextEditingController(text: widget.person?.address ?? ''),
      TextEditingController(text: widget.person?.phoneNumber ?? ''),
      TextEditingController(text: widget.person?.bgNumber ?? ''),
    ];

    _selectedGender = widget.person?.gender ?? Gender.male;
    super.initState();
  }

  @override
  void dispose() {
    _controllers.forEach((controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text(Strings.user),
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          splashRadius: 20,
          icon: Icon(CupertinoIcons.back),
        ),
        elevation: 1,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: Strings.user,
        onPressed: () {
          _updateUser();
        },
        child: Icon(Icons.check),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        // crossAxisAlignment: CrossAxisAlignment.start,
        padding:
            const EdgeInsets.only(left: 32, top: 16, right: 16, bottom: 80),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(Strings.firstName),
          ),
          SizedBox(height: 4),
          TextField(
            controller: _controllers[0],
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(Strings.lastName),
          ),
          SizedBox(height: 4),
          TextField(
            controller: _controllers[1],
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(Strings.birthdate),
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                  child: TextField(
                controller: _controllers[2],
                enabled: false,
              )),
              SizedBox(width: 16),
              Material(
                color: AppColor.secondary,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () async {
                    selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              onPrimary: AppColor.white,
                              primary: AppColor.primary,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (selectedDate == null) {
                      return;
                    }

                    String date =
                        DateFormat('yyyy/MM/dd').format(selectedDate!);
                    _controllers[2].text = date;
                  },
                  child: SizedBox(
                    height: 44,
                    width: 44,
                    child: Icon(
                      Icons.date_range,
                      color: AppColor.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(Strings.gender),
          ),
          SizedBox(height: 4),
          AppDropDown(
            selectedValue: _selectedGender,
            items: Gender.values,
            onSelected: (value) {
              _selectedGender = value as Gender;
              setState(() {});
            },
          ),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(Strings.school),
          ),
          SizedBox(height: 4),
          TextField(
            controller: _controllers[3],
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            onSubmitted: (value) {
              FocusScope.of(context).nextFocus();
            },
          ),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(Strings.address),
          ),
          SizedBox(height: 4),
          TextField(
            controller: _controllers[4],
            keyboardType: TextInputType.streetAddress,
            textInputAction: TextInputAction.next,
            onSubmitted: (value) {
              FocusScope.of(context).nextFocus();
            },
          ),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(Strings.phoneNumber),
          ),
          SizedBox(height: 4),
          TextField(
            controller: _controllers[5],
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            onSubmitted: (value) {
              FocusScope.of(context).nextFocus();
            },
          ),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(Strings.bgNumber),
          ),
          SizedBox(height: 4),
          TextField(
            controller: _controllers[6],
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }

  void _updateUser() {
    String firstName = _controllers[0].text;
    String lastName = _controllers[1].text;
    String school = _controllers[3].text;
    String address = _controllers[4].text;
    String phoneNumber = _controllers[5].text;
    String bgNumber = _controllers[6].text;
    Gender gender = _selectedGender;
    int? birthDate = selectedDate?.millisecondsSinceEpoch;
    if (firstName.isEmpty) {
      showSnackbar(context, Strings.enterFirstName);
      return;
    }
    Person person = Person(
      id: widget.person?.id,
      firstName: firstName,
      lastName: lastName,
      gender: gender,
      phoneNumber: phoneNumber,
      bgNumber: bgNumber,
      school: school,
      address: address,
      birthDate: birthDate,
      date: DateTime.now().millisecondsSinceEpoch,
    );
    // BlocProvider.of<UserBloc>(context).add(UserUpdate(user));
    context.read<PersonBloc>().add(PersonUpdate(person));
    Navigator.of(context).pop();
  }
}
