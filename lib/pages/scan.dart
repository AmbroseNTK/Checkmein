import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:checkmein/customs/snackbar_custom.dart';
import 'package:checkmein/database.dart';
import 'package:checkmein/resources.dart';
import 'package:checkmein/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:checkmein/models/event.dart';
import 'dart:js' as js;

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
    super.dispose();
    print("SCAN DISPOSE");
    streamControllerBuilderForScaning.sink.close();
    turnOffCamera();
    removeCameraElemnt();
  }

  Key key = UniqueKey();
  @override
  void initState() {
    super.initState();
    print("SCAN INIT STAE");
    _webcamVideoElement = new VideoElement();
// ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
        'webcamVideoElement', (int viewId) => _webcamVideoElement);

    _webcamWidget = HtmlElementView(key: key, viewType: 'webcamVideoElement');
    document.body.append(_webcamVideoElement);
    rehookCamera(); // Handle reopen MediaStream and Capture
  }

  void rehookCamera() {
    window.navigator.getUserMedia(audio: false,
        // video: true
        video: {
          "facingMode": {"exact": "environment"}
        }).then((MediaStream mediaStream) {
      _mediaStream = mediaStream;

      _webcamVideoElement.srcObject = mediaStream;
      _webcamVideoElement.id = "WEBCAM";
      _webcamVideoElement.className = "WEBCAMCLASS";

      ; // _webcamVideoElement.on
      _webcamVideoElement.autoplay = true;
      _webcamVideoElement.onPlay.capture((event) {
        print("onPlay");
      });
      // if (_webcamVideoElement.srcObject.active) {
      //   _webcamVideoElement.play();
      // }
    });
  }

  Widget spinkit(double rectSize) => SpinKitCubeGrid(
        color: Colors.white,
        size: rectSize,
      );

  Widget buildeventInfoCardTitile(Size size, String titleofState) {
    return Container(
      padding: EdgeInsets.all(15),
      alignment: Alignment.topCenter,
      width: double.infinity,
      height: size.height * 0.1,
      color: Colors.greenAccent,
      child: Align(
        alignment: Alignment.center,
        child: Text(titleofState,
            style: TextStyle(
                fontFamily: 'FiraSans',
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget eventInfoCardContent(Event eventInfo, Size size) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: size.height * 0.4,
        width: size.width * 0.8,
        child: Align(
          alignment: Alignment.center,
          child: Column(
            // crossAxisAlignment: Cro,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Event Name : " + eventInfo.name, style: R.textHeading3L),
              Text("Event Location : " + eventInfo.location,
                  style: R.textHeading3L),
              Text("Time : " +
                  DateTime.fromMillisecondsSinceEpoch(eventInfo.startDay)
                      .toString())
            ],
          ),
        ),
      ),
    );
  }

  Widget eventInfoCard(
      {Event eventInfo, ENTER_EVENT_STATE eventState, Size size}) {
    return Card(
      child: Container(
        width: size.width * 0.35,
        height: size.width * 0.35,
        // color: Colors.blue ,
        child: Stack(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            eventState == ENTER_EVENT_STATE.NEW
                ? buildeventInfoCardTitile(size, "Sussesfully")
                : buildeventInfoCardTitile(size, "Already Attended"),
            eventInfoCardContent(eventInfo, size)
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: R.colorPrimary,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 5.0, 0),
          child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(AppRouting.menu);
              }),
        ),
        title: Text(
          'Checkmein',
          style: R.textHeadingWhite,
        ),
      ),
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
                stream: _streamBuilderForScaning, // Reactive changing UI
                initialData: SCANING_STATE.FAIL,
                builder: (BuildContext context,
                    AsyncSnapshot<SCANING_STATE> snapshot) {
                  print("Call StreamBuilder" + snapshot.data.toString());
                  if (snapshot.data == SCANING_STATE.SCANING) {
                    this.hideCamera(true);
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
                    // this.hideCamera(false);
                    // rehookCamera();
                    return Container();
                  }

                  return Container();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: FloatingActionButton(
                onPressed: () async {
                  _webcamVideoElement.srcObject.active
                      ? _webcamVideoElement.play()
                      : _webcamVideoElement.pause();
                  this.hideCamera(true);
                  if (_webcamVideoElement.srcObject != null) {
                    if (_webcamVideoElement.srcObject.active) {
                      ImageCapture capture = ImageCapture(
                          _webcamVideoElement.srcObject.getVideoTracks().first);
                      Blob blob = await capture.takePhoto();

                      print("Blob capture size 🌁 : ${blob.size}");
                      this.changeScanFlag(SCANING_STATE.SCANING);
                      this.turnOffCamera();

                      String qrDecode = await Database.callQRDecodeAPI(blob);
                      // String qrDecode = "";
                      if (qrDecode != null && qrDecode.length > 5) {
                        print(qrDecode);
                        var eventEnterResult =
                            await Database().addUserToEvent(qrDecode);

                        // Handle UI EVENT ID NOT FOUND
                        if (eventEnterResult == ENTER_EVENT_STATE.ERROR) {
                          _confirmDialog(
                              title: "Error",
                              content: "Unable to find Event",
                              lowerContent: "Please Rescan");
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
                        this.hideCamera(false);
                        // Unable to locate QR code in the picture ( server respone with null )
                        print("NO QR in PICTURE");
                        _confirmDialog(
                            title: "Error",
                            content: "Unable to find QRCode",
                            lowerContent: "Please Rescan");
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

  void hideCamera(bool cameraToggleHide) {
    _webcamVideoElement.style.zIndex = cameraToggleHide == true ? "-1" : "1";
  }

  void removeCameraElemnt() {
    _webcamVideoElement?.remove();
  }

  void turnOffCamera() {
    // if (_mediaStream.active) {
    _mediaStream.getTracks().forEach((track) {
      track.stop();
      _webcamVideoElement.srcObject.removeTrack(track);
    });
    // _mediaStream.getTracks()[0].stop();
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

  Future<void> _confirmDialog(
      {String title, String content, String lowerContent}) async {
    this.hideCamera(true);
    switch (await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
              title: Text(title, style: R.textTitleL),
              contentPadding: const EdgeInsets.fromLTRB(24.0, 5.0, 24.0, 24.0),
              children: <Widget>[
                Text(
                  content,
                  style: TextStyle(
                      fontFamily: 'FiraSans',
                      fontSize: 13,
                      color: R.colorBlack,
                      fontWeight: FontWeight.normal),
                ),
                Text(
                  lowerContent,
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
        this.hideCamera(false);
        this.rehookCamera();
        this.changeScanFlag(SCANING_STATE.FAIL);
        print('Confirmed');
        break;

      case false:
        print('Canceled');
        break;

      default:
        this.hideCamera(false);
        this.rehookCamera();
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
