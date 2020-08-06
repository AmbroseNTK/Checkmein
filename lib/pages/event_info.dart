import 'package:checkmein/database.dart';
import 'package:checkmein/models/event.dart';
import 'package:checkmein/pages/checkin_page.dart';
import 'package:checkmein/pages/menu.dart';
import 'package:checkmein/resources.dart';
import 'package:checkmein/utils.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class EventInfoPage extends StatefulWidget {
  final Event event;
  final bool isUpdate;
  const EventInfoPage({Key key, this.event, this.isUpdate = false})
      : super(key: key);
  @override
  _EventInfoPageState createState() => _EventInfoPageState();
}

class _EventInfoPageState extends State<EventInfoPage> {
  final sizedBoxspace = SizedBox(height: 20);
  String eventName = "";
  String eventLocation = "";
  int eventDuration = 0;
  final format = DateFormat("yyyy-MM-dd HH:mm");

  bool autoValidate = false;
  bool readOnly = true;
  bool showResetIcon = true;
  DateTime value = DateTime.now();
  int changedCount = 0;
  int savedCount = 0;

  @override
  void initState() {
    super.initState();
    print(widget.isUpdate);

    if (widget.isUpdate) {
      setState(() {
        eventName = widget.event.name;
        eventLocation = widget.event.location;
        eventDuration = widget.event.duration;
        selectedDate =
            DateTime.fromMillisecondsSinceEpoch(widget.event.startDay);
      });
    }
  }

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
                      initialValue: eventName,
                      onChanged: (value)=>{
                        this.eventName = value
                      },
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
                      onChanged: (value)=>{
                        this.eventLocation = value
                      },
                      initialValue: eventLocation,
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
                    DateTimeField(
                      onChanged: (value) {
                        this.selectedDate = value;
                      },
                      initialValue: selectedDate,
                      maxLength: 20,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        icon: Icon(Icons.access_alarms),
                        border: const OutlineInputBorder(),
                        helperText: "Write the date of yours event",
                      ),
                      format: DateFormat("yyyy-MM-dd HH:mm a"),
                      onShowPicker: (context, currentValue) async {
                        final date = await showDatePicker(
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: R.colorPrimary,
                                    onPrimary: R.colorBlack,
                                    onError: R.colorError,
                                    onSurface: R.colorBlack,
                                  ),
                                  dialogBackgroundColor: R.colorWhite,
                                ),
                                child: child,
                              );
                            },
                            context: context,
                            initialDate:
                                widget.isUpdate ? selectedDate : DateTime.now(),
                            firstDate:
                                widget.isUpdate ? selectedDate : DateTime.now(),
                            lastDate: DateTime(2100));
                        if (date != null) {
                          final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                  widget.isUpdate
                                      ? selectedDate
                                      : DateTime.now()));
                          return DateTimeField.combine(date, time);
                        } else {
                          return currentValue;
                        }
                      },
                      autovalidate: autoValidate,
                      validator: (date) => date == null ? 'Invalid date' : null,
                      // initialValue: initialValue,
                      onSaved: (date) => setState(() {
                        value = date;
                        savedCount++;
                      }),
                      resetIcon: showResetIcon ? Icon(Icons.delete) : null,
                      readOnly: readOnly,
                    ),
                    sizedBoxspace,
                    TextFormField(
                      onChanged: (value)=>{
                        this.eventDuration = int.parse(value)
                      },
                      initialValue: eventDuration.toString(),
                      onFieldSubmitted: (value) =>
                          eventDuration = int.parse(value),
                      maxLength: 3,
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
                            widget.isUpdate
                                ? _buildUpdateButton()
                                : _buildSaveButton(),
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

  RaisedButton _buildSaveButton() {
    return RaisedButton(
      color: R.colorPrimary,
      onPressed: () async {
        if (eventName == "") {
          showSnackBar("Please enter event's name");
          return;
        } else if (eventLocation == "") {
          showSnackBar("Please enter event's location");
          return;
        } else if (eventDuration == 0) {
          showSnackBar("Please enter event's duration ");
          return;
        } else {
          try {
            await Database()
                .saveEvent(Event(
              duration: eventDuration,
              name: eventName,
              location: eventLocation,
              startDay: selectedDate.millisecondsSinceEpoch,
            ))
                .then((value) {
              showSnackBar("$eventName was saved");
              // Navigator.of(context).pop();
              // // Navigator.
              // Navigator.of(context).pushNamed('/menu');
            });
          } catch (e) {
            print(e);
            showSnackBar("Failed to save $eventName");
          }
        }
      },
      child: Text(
        'Save',
        style: R.textHeading3L,
      ),
    );
  }

  RaisedButton _buildUpdateButton() {
    return RaisedButton(
      color: R.colorPrimary,
      onPressed: () async {
        if (eventName == "") {
          showSnackBar("Please enter event's name");
          return;
        } else if (eventLocation == "") {
          showSnackBar("Please enter event's location");
          return;
        } else if (eventDuration == 0) {
          showSnackBar("Please enter event's duration ");
          return;
        } else {
          try {
            await Database()
                .updateEvent(
                    widget.event.eventId,
                    Event(
                        duration: eventDuration,
                        location: eventLocation,
                        name: eventName,
                        startDay: selectedDate.millisecondsSinceEpoch))
                .then((value) {
              showSnackBar("$eventName was updated");
              // if (Navigator.canPop(context)) {
              //   Navigator.of(context).pop();
              //   Navigator.of(context).pushNamed('/menu');
              // }
            });
          } catch (e) {
            print(e);
            showSnackBar("Failed to update $eventName");
          }
        }
      },
      child: Text(
        'Update',
        style: R.textHeading3L,
      ),
    );
  }

  void navigatorGoBack(){
    // Navigator.of(context).popUntil(ModalRoute.withName('/menu'));
    // .popUntil(ModalRoute.withName('/menu'));
  }

  DateTime selectedDate = DateTime.now();
  void showSnackBar(String mess) {
    // navigatorGoBack();
    Flushbar(
      onStatusChanged: (status) => {
        if (FlushbarStatus.DISMISSED == status) {
          Future.delayed(Duration(seconds: 1)).then((value) => {
            Navigator.of(context).pop(),
            Navigator.of(context).pop(),
            // this.navigatorGoBack()
          })
        }
      },
      
      animationDuration: Duration(seconds: 1),
      message: mess,
      icon: Icon(
        Icons.info,
        color: R.colorPrimary,
      ),
      duration: Duration(seconds: 2),
    ).show(context);
  }
}