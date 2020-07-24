import 'package:checkmein/customs/poly_state.dart';
import 'package:checkmein/database.dart';
import 'package:checkmein/models/user.dart';
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
        child: SizedBox(
          width: Utils.valueBetween(
              200, 700, MediaQuery.of(context).size.width * 0.4),
          height: Utils.valueBetween(
              200, 700, MediaQuery.of(context).size.height * 0.4),
          child: Card(
            elevation: 12,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Checkmein",
                  style: R.textTitleL,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 40,
                ),
                RaisedButton.icon(
                  onPressed: () async {
                    var user = await login();
                    print(user.email);
                    await Database().getEvents();
                  },
                  color: R.colorSecondary,
                  icon: ImageIcon(NetworkImage(
                      "https://cdn4.iconfinder.com/data/icons/new-google-logo-2015/400/new-google-favicon-512.png",
                      scale: 0.2)),
                  label: Text("Login", style: R.textNormalBlackForL),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildM(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colorPrimary,
      body: Center(
        child: SizedBox(
          width: Utils.valueBetween(
              500, 1500, MediaQuery.of(context).size.width * 0.4),
          height: Utils.valueBetween(
              500, 1500, MediaQuery.of(context).size.height * 0.4),
          child: Card(
            elevation: 12,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Checkmein",
                  style: R.textTitleS,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 40,
                ),
                RaisedButton.icon(
                  onPressed: () async {
                    var user = await login();
                    print(user.email);
                    await Database().getEvents();
                  },
                  color: R.colorSecondary,
                  icon: ImageIcon(NetworkImage(
                      "https://cdn4.iconfinder.com/data/icons/new-google-logo-2015/400/new-google-favicon-512.png",
                      scale: 0.2)),
                  label: Text("Login", style: R.textNormalBlackForS),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildL(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colorPrimary,
      body: Center(
        child: SizedBox(
          width: Utils.valueBetween(
              500, 1500, MediaQuery.of(context).size.width * 0.4),
          height: Utils.valueBetween(
              500, 1500, MediaQuery.of(context).size.height * 0.4),
          child: Card(
            elevation: 12,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Checkmein",
                  style: R.textTitleL,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 40,
                ),
                RaisedButton.icon(
                  onPressed: () async {
                    var user = await login();
                    print(user.email);
                    await Database().getEvents();
                  },
                  color: R.colorSecondary,
                  icon: ImageIcon(NetworkImage(
                      "https://cdn4.iconfinder.com/data/icons/new-google-logo-2015/400/new-google-favicon-512.png",
                      scale: 0.2)),
                  label: Text("Login", style: R.textNormalBlackForL),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildXL(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colorPrimary,
      body: Center(
        child: SizedBox(
          width: Utils.valueBetween(
              500, 1500, MediaQuery.of(context).size.width * 0.4),
          height: Utils.valueBetween(
              500, 1500, MediaQuery.of(context).size.height * 0.4),
          child: Card(
            elevation: 12,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Checkmein",
                  style: R.textTitleL,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 40,
                ),
                RaisedButton.icon(
                  onPressed: () async {
                    var user = await login();
                    print(user.email);
                    await Database().getEvents();
                  },
                  color: R.colorSecondary,
                  icon: ImageIcon(NetworkImage(
                      "https://cdn4.iconfinder.com/data/icons/new-google-logo-2015/400/new-google-favicon-512.png",
                      scale: 0.2)),
                  label: Text("Login", style: R.textHeading1L),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
