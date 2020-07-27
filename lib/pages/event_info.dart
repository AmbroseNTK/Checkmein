import 'package:checkmein/database.dart';
import 'package:checkmein/models/event.dart';
import 'package:checkmein/pages/checkin_page.dart';
import 'package:checkmein/resources.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class EventInfoPage extends StatefulWidget {
  @override
  _EventInfoPageState createState() => _EventInfoPageState();
}

class _EventInfoPageState extends State<EventInfoPage> {
  final sizedBoxspace = SizedBox(height: 20);
  String eventName = "";
  String eventLocation = "";
  int eventDuration = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colorPrimary,
      appBar: AppBar(
        title: Text(
          "Event Information",
          style: R.textHeadingWhite,
        ),
        backgroundColor: R.colorPrimary,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/event.png', width: 25.0),
        ),
        actions: [
          FlatButton.icon(
              label: Text(
                "Check-in",
                style: R.textHeadingWhite,
              ),
              icon: Icon(
                Icons.check_circle,
                color: R.colorWhite,
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return CheckinPage();
                }));
              })
        ],
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0)),
                  color: R.colorWhite,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black38, spreadRadius: 5, blurRadius: 10),
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      onFieldSubmitted: (value) => eventName = value.trim(),
                      maxLength: 50,
                      keyboardType: TextInputType.text,
                      cursorColor: R.colorPrimary,
                      decoration: InputDecoration(
                          icon: Icon(Icons.insert_invitation),
                          border: const OutlineInputBorder(),
                          hintText: "Type your event's name",
                          helperText: "Write the name of yours event"),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    sizedBoxspace,
                    TextFormField(
                      onFieldSubmitted: (value) => eventLocation = value.trim(),
                      maxLength: 20,
                      keyboardType: TextInputType.text,
                      cursorColor: R.colorPrimary,
                      decoration: InputDecoration(
                          icon: Icon(Icons.location_on),
                          border: const OutlineInputBorder(),
                          hintText: "Type your event's location",
                          helperText: "Write the location of yours event"),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    sizedBoxspace,
                    TextFormField(
                      maxLength: 20,
                      keyboardType: TextInputType.datetime,
                      cursorColor: R.colorPrimary,
                      readOnly: true,
                      decoration: InputDecoration(
                        icon: Icon(Icons.access_alarms),
                        border: const OutlineInputBorder(),
                        hintText: "$selectedDate",
                        labelText: "$selectedDate",
                        labelStyle: R.textHeading3L,
                        helperText: "Write the date of yours event",
                        suffix: RaisedButton(
                            color: R.colorPrimary,
                            child: Text(
                              "Select date",
                              style: R.textHeading3L,
                            ),
                            onPressed: () {
                              // _selectDate(context);
                              DatePicker.showDateTimePicker(context,
                                  showTitleActions: true, onChanged: (date) {
                                print('change $date in time zone ' +
                                    date.timeZoneOffset.inHours.toString());
                              }, onConfirm: (date) {
                                print('confirm $date');
                                setState(() {
                                  selectedDate = date;
                                });
                              }, currentTime: DateTime.now());
                            }),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your date';
                        }
                        return null;
                      },
                    ),
                    sizedBoxspace,
                    TextFormField(
                      onFieldSubmitted: (value) =>
                          eventDuration = int.parse(value),
                      maxLength: 5,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      cursorColor: R.colorPrimary,
                      decoration: InputDecoration(
                          icon: Icon(Icons.av_timer),
                          border: const OutlineInputBorder(),
                          hintText: "Type your event's duration (ie. minutes)",
                          helperText: "Write the duration of yours event"),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your duration';
                        }
                        return null;
                      },
                    ),
                    sizedBoxspace,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            RaisedButton(
                              color: R.colorError,
                              onPressed: () {},
                              child: Text(
                                'Clear Participanted Uers',
                                style: R.textNormalWhiteForL,
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(right: 8.0)),
                            RaisedButton(
                              color: R.colorPrimary,
                              onPressed: () async {
                                if (eventName == "") {
                                  showSnackBar(
                                      "Please enter event's name", context);
                                  return;
                                } else if (eventLocation == "") {
                                  showSnackBar(
                                      "Please enter event's location", context);
                                  return;
                                } else if (eventDuration == 0) {
                                  showSnackBar("Please enter event's duration ",
                                      context);
                                  return;
                                } else {
                                  try {
                                    await Database().saveEvent(Event(
                                      duration: eventDuration,
                                      name: eventName,
                                      location: eventLocation,
                                      startDay:
                                          selectedDate.millisecondsSinceEpoch,
                                    ));
                                    showSnackBar(
                                        "$eventName was saved", context);
                                  } catch (e) {
                                    print(e);
                                    showSnackBar(
                                        "Failed to save $eventName", context);
                                  }
                                }
                              },
                              child: Text(
                                'Save',
                                style: R.textHeading3L,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DateTime selectedDate = DateTime.now();
  void showSnackBar(String mess, BuildContext ctx) {
    Flushbar(
      animationDuration: Duration(seconds: 1),
      message: mess,
      icon: Icon(
        Icons.info,
        color: R.colorPrimary,
      ),
      duration: Duration(seconds: 3),
    ).show(context);
  }
}
