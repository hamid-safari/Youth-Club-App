// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_function_literals_in_foreach_calls

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting/data/admin/bloc/admin_bloc.dart';
import 'package:meeting/theme/app_color.dart';
import 'package:meeting/utils/strings.dart';
import 'package:meeting/utils/utils.dart';

class CreateAdminSscreen extends StatefulWidget {
  const CreateAdminSscreen({super.key});

  @override
  State<CreateAdminSscreen> createState() => _CreateAdminSscreenState();
}

class _CreateAdminSscreenState extends State<CreateAdminSscreen> {
  bool _visible = false;
  final List<TextEditingController> _controllers = [
    TextEditingController(),
    TextEditingController(),
  ];

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
      backgroundColor: AppColor.primaryText,
      body: BlocProvider(
        create: (context) => AdminBloc(),
        child: BlocConsumer<AdminBloc, AdminState>(
          listener: (context, state) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (state is AdminError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              } else if (state is AdminCreated) {
                showSnackbar(context, 'New admin created successfully');
                Navigator.of(context).pop();
              }
            });
          },
          builder: (context, state) {
            return Center(
              child: ListView(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.all(32),
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 180,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Create new admin',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: AppColor.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 32),
                  TextField(
                    controller: _controllers[0],
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: Strings.email,
                      fillColor: AppColor.surface,
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: _controllers[1],
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    obscureText: !_visible,
                    decoration: InputDecoration(
                        hintText: Strings.password,
                        fillColor: AppColor.surface,
                        suffixIcon: IconButton(
                          icon: Icon(_visible
                              ? CupertinoIcons.eye_slash_fill
                              : CupertinoIcons.eye_fill),
                          onPressed: () {
                            setState(() {
                              _visible = !_visible;
                            });
                          },
                        )),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    onPressed: state is AdminLoading
                        ? null
                        : () {
                            String email = _controllers[0].text.trim();
                            String password = _controllers[1].text.trim();
                            context.read<AdminBloc>().add(
                                AdminCreate(email: email, password: password));
                          },
                    child: state is AdminLoading
                        ? CircularProgressIndicator(
                            color: AppColor.white,
                          )
                        : Text(
                            'Create',
                            style: Theme.of(context).textTheme.button?.copyWith(
                                  color: AppColor.white,
                                ),
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
