import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:checkmein/customs/snackbar_custom.dart';
import 'package:checkmein/database.dart';
import 'package:checkmein/resources.dart';
import 'package:checkmein/utils.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:checkmein/models/event.dart';

class ScanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ScanPageState();
  }
}

class ScanPageState extends State<ScanPage> {
  Widget _webcamWidget;
  VideoElement _webcamVideoElement;
  MediaStream _mediaStream;
  SCANING_STATE sucessFlag = SCANING_STATE.FAIL;
  Event _eventInfo;

  StreamController<SCANING_STATE> streamControllerBuilderForScaning =
      new StreamController();
  Stream<SCANING_STATE> get _streamBuilderForScaning =>
      streamControllerBuilderForScaning.stream;

  ScanPageState() {}

  @override
  void dispose() {
    streamControllerBuilderForScaning.sink.close();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _webcamVideoElement = VideoElement();

    ui.platformViewRegistry.registerViewFactory(
        'webcamVideoElement', (int viewId) => _webcamVideoElement);

    _webcamWidget =
        HtmlElementView(key: UniqueKey(), viewType: 'webcamVideoElement');
    rehookCamera(); // Handle reopen MediaStream and Capture
  }

  void rehookCamera() {
    window.navigator
        .getUserMedia(audio: false, video: true
            // video: {
            //   "facingMode": {"exact": "environment"}
            // }
            )
        .then((MediaStream mediaStream) {
      _mediaStream = mediaStream;
      _webcamVideoElement.srcObject = mediaStream;
      _webcamVideoElement.autoplay = true;
      // if (_webcamVideoElement.srcObject.active) {
      //   _webcamVideoElement.play();
      // }
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

  Widget spinkit(double rectSize) => SpinKitCubeGrid(
        color: Colors.white,
        size: rectSize,
      );

  Widget eventInfoCard(
      {Event eventInfo, ENTER_EVENT_STATE eventState, Size size}) {
    return Card(
      child: Container(
        width: size.width * 0.35,
        height: size.width * 0.35,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            eventState == ENTER_EVENT_STATE.NEW
                ? Text(
                    "Sussesfully",
                    style: TextStyle(
                        fontFamily: 'FiraSans',
                        fontSize: 19,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  )
                : Text("Already Attended"),
            Text(eventInfo.name, style: R.textHeading3L)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size mediaquery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: R.colorPrimary,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Scan to checkin',
              style: R.textTitleL,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.height * 0.7,
              child: StreamBuilder<SCANING_STATE>(
                stream: _streamBuilderForScaning,
                initialData: SCANING_STATE.FAIL,
                builder: (BuildContext context,
                    AsyncSnapshot<SCANING_STATE> snapshot) {
                  print("Call StreamBuilder" + snapshot.data.toString());
                  if (snapshot.data == SCANING_STATE.SCANING) {
                    return spinkit(mediaquery.width * 0.35);
                  }
                  if (snapshot.data == SCANING_STATE.SUCCESS) {
                    return eventInfoCard(
                        eventInfo: this._eventInfo,
                        eventState: ENTER_EVENT_STATE.NEW,
                        size: mediaquery);
                  }
                  if (snapshot.data == SCANING_STATE.SUCCESS_EXISTS) {
                    return eventInfoCard(
                        eventInfo: this._eventInfo,
                        eventState: ENTER_EVENT_STATE.EXISTED,
                        size: mediaquery);
                  }
                  if (snapshot.data == SCANING_STATE.FAIL) {
                    rehookCamera();
                    return _webcamWidget;
                  }

                  return Container();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: FloatingActionButton(
                onPressed: () async {
                  // _webcamVideoElement.srcObject.active
                  //     ? _webcamVideoElement.play()
                  //     : _webcamVideoElement.pause();
                  if (_webcamVideoElement.srcObject != null) {
                    if (_webcamVideoElement.srcObject.active) {
                      ImageCapture capture = ImageCapture(
                          _webcamVideoElement.srcObject.getVideoTracks().first);
                      Blob blob = await capture.takePhoto();

                      print("Blob capture size 🌁 : ${blob.size}");
                      streamControllerBuilderForScaning.sink
                          .add(SCANING_STATE.SCANING);
                      this.turnOffCamera();

                      String qrDecode = await Database.callQRDecodeAPI(blob);
                      // String qrDecode = "";
                      if (qrDecode != null && qrDecode.length > 5) {
                        print(qrDecode);
                        var eventEnterResult =
                            await Database().addUserToEvent(qrDecode);

                        // Handle UI EVENT ID NOT FOUND
                        if (eventEnterResult == ENTER_EVENT_STATE.ERROR) {
                          var dialogResult = await showDialog<String>(
                              context: context,
                              builder: (BuildContext context) {
                                return buildAlertDialog(
                                    "Error", ["Event not found"], "Rescan");
                              });
                          print(dialogResult);
                          this.changeScanFlag(SCANING_STATE.FAIL);
                        } else {
                          // BEGIN TO FIND EVENT
                          _eventInfo =
                              await new Database().getEventInfo(qrDecode);
                          switch (eventEnterResult) {
                            case ENTER_EVENT_STATE.EXISTED:
                              this.changeScanFlag(SCANING_STATE.SUCCESS_EXISTS);
                              break;
                            case ENTER_EVENT_STATE.NEW:
                              // UI DELAY
                              Future.delayed(Duration(seconds: 1)).then(
                                  (value) => streamControllerBuilderForScaning
                                      .sink
                                      .add(SCANING_STATE.SUCCESS));
                              break;
                            default:
                          }
                        }
                      } else {
                        // this.changeScanFlag(SCANING_STATE.FAIL);
                        print("NULL WHEN CALL API");
                        _confirmDialog();
                      }
                    }
                  }
                },
                tooltip: "Start camera",
                child: Icon(Icons.camera),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void turnOffCamera() {
    // if (_mediaStream.active) {
    // _mediaStream.getTracks().forEach((element) {
    //   element.stop();
    // });
    _mediaStream.getTracks()[0].stop();
    // }
  }

  void changeScanFlag(SCANING_STATE state) {
    this.streamControllerBuilderForScaning.sink.add(state);
  }

  buildAlertDialog(String title, List<String> content, String buttonText) {
    return AlertDialog(
      title: Text(title, style: R.textHeading1L),
      content: ListBody(
        children: content
            .map((contentValue) => Text(
                  contentValue,
                  style: R.textHeading2S,
                ))
            .toList(),
      ),
      actions: [
        FlatButton(
            onPressed: () {
              Navigator.of(context).pop("OK RESCAN");
            },
            child: Text(buttonText))
      ],
    );
  }

  Future<void> _confirmDialog() async {
    switch (await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
              title: Text('Error', style: R.textTitleL),
              contentPadding: const EdgeInsets.fromLTRB(24.0, 5.0, 24.0, 24.0),
              children: <Widget>[
                Text(
                  "Unable to find QRCode",
                  style: TextStyle(
                      fontFamily: 'FiraSans',
                      fontSize: 13,
                      color: R.colorBlack,
                      fontWeight: FontWeight.normal),
                ),
                Text(
                  "Please Rescan",
                  style: TextStyle(
                      fontFamily: 'FiraSans',
                      fontSize: 10,
                      color: R.colorBlack,
                      fontWeight: FontWeight.normal),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: const Text(
                        'Rescan',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ]);
        })) {
      case true:
        this.changeScanFlag(SCANING_STATE.FAIL);
        print('Confirmed');
        break;

      case false:
        print('Canceled');
        break;

      default:
        this.changeScanFlag(SCANING_STATE.FAIL);
        print('Canceled');
    }
  }
}

// FileSystem _filesystem = await window
//     .requestFileSystem(blob.size, persistent: false);
// FileEntry fileEntry =
//     await _filesystem.root.createFile('capture.png');
// FileWriter fw = await fileEntry.createWriter();
// fw.write(blob);
// var file = await fileEntry.file();

// print("FileEntry : ${fileEntry.fullPath}");
// print("FileEntry.file() : ${file.relativePath}");
// FileReader reader = FileReader();
// reader.readAsArrayBuffer(blob);
// print(reader.result.toString());

// await callQRDecodeAPI(blob, context);
// print("Done");
