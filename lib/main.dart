import 'package:checkmein/pages/checkin_page.dart';
import 'package:checkmein/pages/event_info.dart';
import 'package:checkmein/pages/event_page.dart';
// import 'package:checkmein/pages/event_update.dart';
import 'package:checkmein/pages/login.dart';
import 'package:checkmein/pages/menu.dart';
// import 'package:checkmein/pages/qr_gen.dart';
import 'package:checkmein/pages/scan.dart';
import 'package:checkmein/resources.dart';
import 'package:checkmein/utils.dart';
import 'package:flutter/material.dart';
final RouteObserver<Route> routeObserver = RouteObserver<Route>();

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: R.colorPrimary,
      accentColor: R.colorSecondary,
    ),
    debugShowCheckedModeBanner: false,
    initialRoute: AppRouting.login,
    routes:{
      AppRouting.menu: (BuildContext context) => MenuPage(),
      AppRouting.event: (BuildContext context) => EventPage(),
      AppRouting.eventInfo: (BuildContext context) => EventInfoPage(),
      AppRouting.login:(BuildContext context)=> LoginPage()
    },
    navigatorObservers:[routeObserver]
  ));
}
