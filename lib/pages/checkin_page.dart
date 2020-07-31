import 'package:checkmein/models/event.dart';
import 'package:checkmein/models/user.dart';
import 'package:checkmein/pages/menu.dart';
import 'package:checkmein/resources.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../database.dart';

class CheckinPage extends StatefulWidget {
  final String event;
  const CheckinPage({Key key, this.event}) : super(key: key);
  @override
  _CheckinPageState createState() => _CheckinPageState();
}

class _CheckinPageState extends State<CheckinPage> {
  // List<Event> listEvents = List();
  List<User> listUsers = List();

  Future<void> loadData() async {
    var result = await Database().getParticipantsByEventId(widget.event);
    setState(() {
      listUsers.clear();
      listUsers.addAll(result);
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    print(listUsers);
    return Scaffold(
      backgroundColor: R.colorPrimary,
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "!",
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontFamily: 'FiraSans',
                  fontSize: 30,
                  color: R.colorWhite,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Checkin",
              style: R.textHeadingWhite,
            ),
          ],
        ),
        backgroundColor: R.colorPrimary,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Image.asset("assets/images/icheckin.png", width: 20.0),
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  Navigator.popAndPushNamed(
                    context,
                    '/menu',
                  );
                },
                icon: Image.asset(
                  'assets/images/real-estate.png',
                  width: 100.0,
                ),
                tooltip: "Go Home",
              ))
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.width * 0.3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        QrImage(
                          data: 'Hello World',
                          version: QrVersions.auto,
                          size: 320,
                          gapless: true,
                          // embeddedImage: AssetImage('assets/images/allow.png'),
                          embeddedImageStyle: QrEmbeddedImageStyle(
                            size: Size(MediaQuery.of(context).size.width,
                                MediaQuery.of(context).size.height),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          VerticalDivider(
            color: Colors.black,
            thickness: 2,
            width: MediaQuery.of(context).size.width * 0.01,
            indent: 100,
            endIndent: 100,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      children: [
                        for (int i = 0; i < listUsers.length; i++)
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: RaisedButton(
                              elevation: 12,
                              color: R.colorWhite,
                              onPressed: () {},
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ExcludeSemantics(
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          CircleAvatar(
                                              radius: 30,
                                              backgroundImage: NetworkImage(
                                                  listUsers[i].photoURL,
                                                  scale: 25.0)),
                                        ],
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: 5.0)),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                listUsers[i].displayName,
                                                style: R.textHeading3L,
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    listUsers[i].email,
                                                    style: R.textHeading3L,
                                                  )
                                                ],
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5.0)),
                                              Column(
                                                children: [
                                                  Text(
                                                    DateTime.fromMillisecondsSinceEpoch(
                                                                listUsers[i]
                                                                    .checkinTime)
                                                            .hour
                                                            .toString() +
                                                        ":" +
                                                        DateTime.fromMillisecondsSinceEpoch(
                                                                listUsers[i]
                                                                    .checkinTime)
                                                            .minute
                                                            .toString() +
                                                        ":" +
                                                        DateTime.fromMillisecondsSinceEpoch(
                                                                listUsers[i]
                                                                    .checkinTime)
                                                            .second
                                                            .toString(),
                                                    style: R.textHeading3L,
                                                  )
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
