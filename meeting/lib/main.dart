import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meeting/data/event/bloc/event_bloc.dart';
import 'package:meeting/data/person/bloc/person_bloc.dart';
import 'package:meeting/data/user_event/bloc/user_event_bloc.dart';
import 'package:meeting/theme/app_color.dart';
import 'package:meeting/ui/screen/login_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:meeting/ui/screen/main_screen.dart';
import 'package:meeting/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Widget initialScreen = await findInitialScreen();

  runApp(MultiBlocProvider(
      providers: [
        BlocProvider<PersonBloc>(create: (context) => PersonBloc()),
        BlocProvider<EventBloc>(create: (context) => EventBloc()),
        BlocProvider<UserEventBloc>(create: (context) => UserEventBloc()),
      ],
      child: const MyApp(
          // initialScreen: initialScreen,
          )));
}

Future<Widget> findInitialScreen() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? isLogin = prefs.getBool(Constants.isLogin);
  if (isLogin != null && isLogin) {
    return const MainScreen();
  }
  return const LoginScreen();
}

class MyApp extends StatelessWidget {
  // final Widget initialScreen;
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: AppColor.primary,
          secondary: AppColor.secondary,
          onSecondary: AppColor.onSecondary,
          onPrimary: AppColor.onPrimary,
        ),
        textTheme: TextTheme(
          headline4:
              GoogleFonts.poppins().copyWith(color: AppColor.secondaryText),
          headline5:
              GoogleFonts.poppins().copyWith(color: AppColor.secondaryText),
          headline6:
              GoogleFonts.poppins().copyWith(color: AppColor.secondaryText, fontSize: 18),
          bodyText1:
              GoogleFonts.poppins().copyWith(color: AppColor.secondaryText, fontSize: 16),
          bodyText2:
              GoogleFonts.poppins().copyWith(color: AppColor.secondaryText, fontSize: 14),
          caption:
              GoogleFonts.poppins().copyWith(color: AppColor.secondaryText),
          button: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColor.secondaryText,
            ),
          ),
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          titleTextStyle: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: AppColor.primaryText,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          isDense: true,
          filled: true,
          hintStyle: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: AppColor.divider,
              fontSize: 14,
            ),
          ),
          fillColor: AppColor.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: BorderSide.none,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColor.primary),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            foregroundColor: AppColor.primary,
            textStyle: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            foregroundColor: AppColor.white,
            textStyle: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          contentTextStyle: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontSize: 14,
            ),
          ),
        ),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const MainScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
