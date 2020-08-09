import 'package:checkmein/customs/poly_state.dart';
import 'package:checkmein/database.dart';
import 'package:checkmein/models/user.dart';
import 'package:checkmein/pages/event_page.dart';
import 'package:checkmein/pages/menu.dart';
import 'package:checkmein/resources.dart';
import 'package:checkmein/signin_service.dart';
import 'package:checkmein/utils.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends PolyState<LoginPage> {
  Future<User> login() async {
    return FirebaseAuthService().signInWithGoogle();
  }

  @override
  Widget buildDefault(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colorPrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/checkmein.png',
              width: 100.0,
            ),
            Text(
              "Checkmein 1.0.3",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 60,
                  fontFamily: 'FiraSans',
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 60,
            ),
            RaisedButton.icon(
                color: Colors.white,
                elevation: 10,
                hoverColor: R.colorWhite,
                icon: Image.asset(
                  "assets/images/gicon.png",
                  width: 25,
                ),
                label: Text(
                  "Login with Google",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontFamily: 'FiraSans',
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: R.colorWhite, width: 2.0)),
                onPressed: () async {
                  var user = await login();
                  Database().saveUsers(user);
                  try {
                    print(user.email);
                    if (user != null) {
                      // await Navigator.popAndPushNamed(context, '/menu');
                      Navigator.of(context).popAndPushNamed(AppRouting.menu);
                    }
                  } catch (e) {
                    print(e.toString());
                  }
                })
          ],
        ),
      ),
    );
  }

  @override
  Widget buildM(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colorPrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/checkmein.png',
              width: 100.0,
            ),
            Text(
              "Checkmein",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 100,
                  fontFamily: 'FiraSans',
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 60,
            ),
            RaisedButton.icon(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: R.colorWhite, width: 2.0)),
              onPressed: () async {
                var user = await login();
                Database().saveUsers(user);
                try {
                  print(user.email);
                  if (user != null) {
                    // await Navigator.popAndPushNamed(context, '/menu');
                      Navigator.of(context).popAndPushNamed(AppRouting.menu);

                  }
                } catch (e) {
                  print(e);
                }
              },
              color: Colors.white,
              elevation: 10,
              hoverColor: R.colorWhite,
              icon: Image.asset(
                "assets/images/gicon.png",
                width: 25,
              ),
              label: Text("Login with Google",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontFamily: 'FiraSans',
                  )),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget buildL(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colorPrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/checkmein.png',
              width: 100.0,
            ),
            Text(
              "Checkmein",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 100,
                  fontFamily: 'FiraSans',
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 60,
            ),
            RaisedButton.icon(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: R.colorWhite, width: 2.0)),
              onPressed: () async {
                var user = await login();
                Database().saveUsers(user);
                try {
                  print(user.email);
                  if (user != null) {
                    // await Navigator.popAndPushNamed(context, '/menu');
                      Navigator.of(context).popAndPushNamed(AppRouting.menu);

                  }
                } catch (e) {
                  print(e);
                }
              },
              color: Colors.white,
              elevation: 10,
              hoverColor: R.colorWhite,
              icon: Image.asset(
                "assets/images/gicon.png",
                width: 25,
              ),
              label: Text("Login with Google",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontFamily: 'FiraSans',
                  )),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget buildXL(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colorPrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/checkmein.png',
              width: 100.0,
            ),
            Text(
              "Checkmein",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 100,
                  fontFamily: 'FiraSans',
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 60,
            ),
            RaisedButton.icon(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: R.colorWhite, width: 2.0)),
              onPressed: () async {
                var user = await login();
                Database().saveUsers(user);
                try {
                  print(user.email);
                  if (user != null) {
                    // await Navigator.popAndPushNamed(context, '/menu');
                      Navigator.of(context).popAndPushNamed(AppRouting.menu);

                  }
                } catch (e) {
                  print(e);
                }
              },
              color: Colors.white,
              elevation: 10,
              hoverColor: R.colorWhite,
              icon: Image.asset(
                "assets/images/gicon.png",
                width: 25,
              ),
              label: Text("Login with Google",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontFamily: 'FiraSans',
                  )),
            )
          ],
        ),
      ),
    );
  }
}
