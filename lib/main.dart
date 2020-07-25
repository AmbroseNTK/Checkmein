import 'package:checkmein/pages/checkin_page.dart';
import 'package:checkmein/pages/event_info.dart';
import 'package:checkmein/pages/event_page.dart';
import 'package:checkmein/pages/login.dart';
import 'package:checkmein/pages/menu.dart';
import 'package:checkmein/pages/scan.dart';
import 'package:checkmein/resources.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: R.colorPrimary,
      accentColor: R.colorSecondary,
    ),
    home: CheckinPage(),
    debugShowCheckedModeBanner: false,
  ));
}
