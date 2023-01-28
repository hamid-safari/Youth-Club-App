// ignore_for_file: unnecessary_type_check

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting/data/admin/admin.dart';
import 'package:meeting/data/person/bloc/person_bloc.dart';
import 'package:meeting/utils/constants.dart';
import 'package:meeting/utils/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  AdminBloc() : super(AdminInitial()) {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    on<AdminStarted>((event, emit) async {
      emit(AdminLoading());
      String email = event.email;
      String password = event.password;
      String? message = await _validate(email, password, 'login');
      if (message != null) {
        emit(AdminError(message: message));
        return;
      }
      await _saveAdminInMemory();
      emit(AdminSuccess(admin: Admin(username: email, password: password)));
    });

    on<AdminCreate>((event, emit) async {
      emit(AdminLoading());
      String email = event.email;
      String password = event.password;
      String? message = await _validate(email, password, 'create');
      if (message != null) {
        emit(AdminError(message: message));
        return;
      }
      await _saveAdminInMemory();
      emit(AdminCreated());
    });
  }

  Future<String?> _validate(String email, String password, String type) async {
    // DataSnapshot snapshot = await ref.child(Constants.adminsKey).get();
    // final data = snapshot.value as Map?;
    // List<Admin> admins = data == null
    //     ? []
    //     : data.values
    //         .map((json) => Admin.fromJson(Map<String, dynamic>.from(json)))
    //         .toList();

    // if (!admins.map((e) => e.username).contains(username)) {
    //   return Strings.incorectAuth;
    // }

    // Admin? admin = admins.firstWhere((admin) => admin.username == username);
    // if (admin.password != password) {
    //   return Strings.incorectAuth;
    // }

    try {
      if (email.isEmpty || password.isEmpty) {
        return Strings.fillFiels;
      }

      if (type == 'login') {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        _saveUser(userCredential);
      } else {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      // if (e.code == 'user-not-found' || e.code == 'wrong-password') {
      //   return Strings.incorectAuth;
      // } else if (e.code == 'invalid-email') {
      //   return Strings.invalidEmail;
      // } else if (e.code == 'email-already-in-use') {
      //   return Strings.emailAlreadyInUse;
      // } else {
      //   return e.toString();
      // }
      return e.message;
    }
  }

  Future<void> _saveAdminInMemory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Constants.isLogin, true);
  }

  void _saveUser(UserCredential userCredential) async {
    String? uid = userCredential.user?.uid ?? '';
    String? email = userCredential.user?.email ?? '';
    usermail.value = email;
    userUid.value = uid;
    debugPrint(uid);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constants.userIdPrefsKey, uid);
    await prefs.setString(Constants.userMailPrefsKey, email);
  }
}
