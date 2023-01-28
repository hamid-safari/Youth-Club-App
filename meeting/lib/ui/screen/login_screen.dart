// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_function_literals_in_foreach_calls

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting/data/admin/bloc/admin_bloc.dart';
import 'package:meeting/theme/app_color.dart';
import 'package:meeting/ui/screen/main_screen.dart';
import 'package:meeting/utils/strings.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
      body: BlocProvider(
        create: (context) => AdminBloc(),
        child: BlocConsumer<AdminBloc, AdminState>(
          listener: (context, state) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (state is AdminError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              }
              //  else if (state is AdminSuccess) {
              // _openMainScreen(context);
              // }
            });
          },
          builder: (context, state) {
            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColor.primaryDark,
                      AppColor.primary,
                      AppColor.primaryLight,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacer(flex: 2),
                    Image.asset(
                      'assets/images/logo.png',
                      height: 240,
                    ),
                    Text(
                      Strings.appName,
                      style: Theme.of(context).textTheme.headline4?.copyWith(
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
                        fillColor: AppColor.white,
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
                          fillColor: AppColor.white,
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
                        primary: AppColor.secondary,
                      ),
                      onPressed:
                          state is AdminLoading ? null : () => _login(context),
                      child: state is AdminLoading
                          ? CircularProgressIndicator(
                              color: AppColor.white,
                            )
                          : Text(
                              Strings.login,
                              style:
                                  Theme.of(context).textTheme.button?.copyWith(
                                        color: AppColor.white,
                                      ),
                            ),
                    ),
                    Spacer(flex: 2),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     GestureDetector(
                    //       onTap: () {
                    //         openUrl(Constants.instagramUrl);
                    //       },
                    //       child: SvgPicture.asset(
                    //         'assets/images/instagram.svg',
                    //         height: 48,
                    //         width: 48,
                    //       ),
                    //     ),
                    //     GestureDetector(
                    //       onTap: () {
                    //         openUrl('mailto:${Constants.mailUrl}');
                    //       },
                    //       child: SvgPicture.asset(
                    //         'assets/images/gmail.svg',
                    //         height: 48,
                    //         width: 48,
                    //       ),
                    //     ),
                    //     GestureDetector(
                    //       onTap: () {
                    //         openUrl(Constants.facebookUrl);
                    //       },
                    //       child: SvgPicture.asset(
                    //         'assets/images/facebook.svg',
                    //         height: 48,
                    //         width: 48,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _login(BuildContext context) {
    String email = _controllers[0].text.trim();
    String password = _controllers[1].text.trim();
    context
        .read<AdminBloc>()
        .add(AdminStarted(email: email, password: password));
  }

  // void _login() {
  //   String username = _controllers[0].text;
  //   String password = _controllers[1].text;
  //   String? message = _validate(username, password);
  //   if (message != null) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text(message)));
  //     return;
  //   }
  //   _openMainScreen(context);
  // }

  // String? _validate(String username, String password) {
  //   if (username.isEmpty || password.isEmpty) {
  //     return 'Please Fill Fields!';
  //   } else if (username != 'admin' || password != '1234') {
  //     return 'Username or Password is not correct.';
  //   }
  //   return null;
  // }

  void _openMainScreen(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => MainScreen()));
  }
}
