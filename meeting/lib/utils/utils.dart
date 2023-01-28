import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';

openUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw 'Could not launch $url';
  }
}

PageTransition transition(Widget child,
    {PageTransitionType type = PageTransitionType.bottomToTop,
    int duration = 250}) {
  return PageTransition(
    type: type,
    child: child,
    duration: Duration(milliseconds: duration),
    reverseDuration: Duration(milliseconds: duration),
    curve: Curves.bounceInOut,
  );
}

showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

String formatDate(DateTime date, {String format = 'yyyy/MM/dd'}) {
  // DateTime dateTime = DateTime.now();
  return DateFormat(format).format(date);
}

bool isToday(int timeStamp) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final date = DateTime.fromMillisecondsSinceEpoch(timeStamp);
  var isToday = today == DateTime(date.year, date.month, date.day);
  return isToday;
}

isSameDate(int first, int second) {
  DateTime firstDate = DateTime.fromMillisecondsSinceEpoch(first);
  DateTime secondDate = DateTime.fromMillisecondsSinceEpoch(second);
  return (firstDate.year == secondDate.year) &&
      (firstDate.month == secondDate.month) &&
      (firstDate.day == secondDate.day);
}
