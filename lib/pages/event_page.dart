import 'package:checkmein/customs/dialog_button.dart';
import 'package:checkmein/customs/snackbar_custom.dart';
import 'package:checkmein/database.dart';
import 'package:checkmein/models/event.dart';
import 'package:checkmein/models/user.dart';
import 'package:checkmein/pages/checkin_page.dart';
import 'package:checkmein/pages/event_info.dart';
import 'package:checkmein/resources.dart';
import 'package:checkmein/utils.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  List<Event> listEvents = List();
  List<User> listUsers = List();

  Event event;
  // bool _isButtonDisabled;
  bool isEnabled = true;

  bool isDataLoaded = false;

  Widget spinkit(double rectSize) => SpinKitFoldingCube(
        color: Colors.white,
        size: rectSize,
      );

  enableButton() {
    setState(() {
      isEnabled = true;
    });
  }

  disableButton() {
    setState(() {
      isEnabled = false;
    });
  }

  Future<void> loadData() async {
    var result = await Database().getEvents();
    setState(() {
      listEvents.clear();
      listEvents.addAll(result);
      isDataLoaded = true;
    });
  }

  void deleteCardAction(){
    setState(() {
      
    });
  }

  @override
  void initState() {
    super.initState();

    loadData();

    // _isButtonDisabled = false;
  }

  @override
  void didUpdateWidget(EventPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget");
  }

  @override
  Widget build(BuildContext context) {
    Size mediaquery = MediaQuery.of(context).size;
    print("List events: " + listEvents.length.toString());
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      settings: RouteSettings(name: AppRouting.eventInfo),
                      builder: (context) => EventInfoPage(
                        callBackUpdateUI: () async {
                          await this.editCallBackFormWidget();
                        },
                      ),
                    ));
              })
        ],
      ),
      backgroundColor: R.colorPrimary,
      body: isDataLoaded == true
          ? Row(
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
                                          listUsers.addAll(
                                              listEvents[i].participants);
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
                                                            listEvents[i]
                                                                .startDay)
                                                        .toString(),
                                                    style: R.textTitleS,
                                                  )
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(children: [
                                                  Row(
                                                    children: [
                                                      IconButton(
                                                          tooltip:
                                                              "Check in now",
                                                          icon: Icon(
                                                            Icons.check_circle,
                                                            color: R.colorBlack,
                                                          ),
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  settings: RouteSettings(
                                                                      name: AppRouting
                                                                          .checkin),
                                                                  builder:
                                                                      (context) =>
                                                                          CheckinPage(
                                                                    event: listEvents[
                                                                            i]
                                                                        .eventId,
                                                                    eventQR: listEvents[
                                                                            i]
                                                                        .eventQR,
                                                                  ),
                                                                ));
                                                          }),
                                                      IconButton(
                                                          tooltip: "Update",
                                                          icon: Icon(
                                                            Icons.edit,
                                                            color: R.colorBlack,
                                                          ),
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  settings: RouteSettings(
                                                                      name: AppRouting
                                                                          .eventInfo),
                                                                  builder: (context) =>
                                                                      EventInfoPage(
                                                                          isUpdate:
                                                                              true,
                                                                          callBackUpdateUI:
                                                                              () async {
                                                                            await this.editCallBackFormWidget();
                                                                          },
                                                                          event:
                                                                              listEvents[i]),
                                                                ));
                                                          }),
                                                      IconButton(
                                                          tooltip:
                                                              "Download file csv",
                                                          icon: Icon(
                                                            Icons
                                                                .arrow_downward,
                                                            color: R.colorBlack,
                                                          ),
                                                          onPressed: () {}),
                                                      IconButton(
                                                          tooltip: "Delete",
                                                          icon: Icon(
                                                            Icons.delete,
                                                            color: R.colorBlack,
                                                          ),
                                                          onPressed: () async {
                                                            await showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return buildDeleteDialog(
                                                                      context,
                                                                      i);
                                                                });
                                                          }),
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
                                                    backgroundImage:
                                                        NetworkImage(
                                                            listUsers[i]
                                                                .photoURL,
                                                            scale: 25.0)),
                                              ],
                                            ),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(left: 5.0)),
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
                                                          style:
                                                              R.textHeading3L,
                                                        )
                                                      ],
                                                    ),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5.0)),
                                                    Column(
                                                      children: [
                                                        Text(
                                                          DateTime.fromMillisecondsSinceEpoch(
                                                                      listUsers[
                                                                              i]
                                                                          .checkinTime)
                                                                  .hour
                                                                  .toString() +
                                                              ":" +
                                                              DateTime.fromMillisecondsSinceEpoch(
                                                                      listUsers[
                                                                              i]
                                                                          .checkinTime)
                                                                  .minute
                                                                  .toString() +
                                                              ":" +
                                                              DateTime.fromMillisecondsSinceEpoch(
                                                                      listUsers[
                                                                              i]
                                                                          .checkinTime)
                                                                  .second
                                                                  .toString(),
                                                          style:
                                                              R.textHeading3L,
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
            )
          : Center(
              child: spinkit(mediaquery.width * 0.3),
            ),
    );
  }

  Future<void> editCallBackFormWidget() async {
    print("editCallBackFormWidget");
    List<Event> updatedResult = await Database().getEvents();

    setState(() {
      listEvents.clear();
      listEvents = updatedResult;
    });
  }

  void showSnackBar(String mess, BuildContext ctx) {
    Flushbar(
      animationDuration: Duration(seconds: 1),
      message: mess,
      icon: Icon(
        Icons.info,
        color: R.colorPrimary,
      ),
      duration: Duration(seconds: 4),
    ).show(context);
  }

  buildDeleteDialog(BuildContext context, int i) {
    return AlertDialog(
      backgroundColor: R.colorWhite,
      contentTextStyle: R.textHeading3L,
      elevation: 12,
      titleTextStyle: R.textTitlePrimary,
      actions: <Widget>[
        new FlatButton(
          child: new Text("Accept", style: R.textHeading3LPrimary),
          onPressed: () async {
            await Database().deleteEvent(listEvents[i].eventId);
            Navigator.pop(context);
            List<Event> updatedResult = await Database().getEvents();

            setState(() {
              listUsers.clear();
              listEvents.clear();
              listEvents = updatedResult;
            });
          },
        ),
        new FlatButton(
            child: new Text(
              "Cancel",
              style: R.textHeading3LPrimary,
            ),
            onPressed: () {
              Navigator.pop(context);
            })
      ],
      title: Text("Delete ${listEvents[i].name}?"),
    );
  }
}
