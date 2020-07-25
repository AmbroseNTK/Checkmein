import 'package:checkmein/database.dart';
import 'package:checkmein/models/event.dart';
import 'package:checkmein/models/user.dart';
import 'package:checkmein/pages/event_info.dart';
import 'package:checkmein/resources.dart';
import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  List<Event> listEvents = List();
  List<User> listUsers = List();

  Future<void> loadData() async {
    var result = await Database().getEvents();
    setState(() {
      listEvents.clear();
      listEvents.addAll(result);
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    print(listEvents.length);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Events',
          style: R.textHeadingWhite,
        ),
        backgroundColor: R.colorPrimary,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/event.png', width: 25.0),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (buildContext) {
                  return EventInfoPage();
                }));
              })
        ],
      ),
      backgroundColor: R.colorPrimary,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height,
                  color: R.colorPrimary,
                  //color: R.colorPrimary,

                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: [
                          for (int i = 0; i < listEvents.length; i++)
                            Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: RaisedButton(
                                color: R.colorWhite,
                                elevation: 12,
                                onPressed: () {
                                  setState(() {
                                    listUsers.clear();
                                    listUsers
                                        .addAll(listEvents[i].participants);
                                  });
                                },
                                child: ExcludeSemantics(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              listEvents[i].name,
                                              style: R.textTitleL,
                                            ),
                                            Text(
                                              DateTime.fromMillisecondsSinceEpoch(
                                                      listEvents[i].startDay)
                                                  .toString(),
                                              style: R.textTitleS,
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(children: [
                                            Row(
                                              children: [
                                                IconButton(
                                                    icon: Icon(
                                                      Icons.edit,
                                                      color: R.colorBlack,
                                                    ),
                                                    onPressed: () {}),
                                                IconButton(
                                                    icon: Icon(
                                                      Icons.arrow_downward,
                                                      color: R.colorBlack,
                                                    ),
                                                    onPressed: () {}),
                                                IconButton(
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color: R.colorBlack,
                                                    ),
                                                    onPressed: () {}),
                                              ],
                                            )
                                          ]),
                                        )
                                      ]),
                                )),
                              ),
                            ),
                        ]),
                  ),
                ),
              )
            ],
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
