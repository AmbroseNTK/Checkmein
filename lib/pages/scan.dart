import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:checkmein/customs/snackbar_custom.dart';
import 'package:checkmein/database.dart';
import 'package:checkmein/resources.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
// import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart' as dio;

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

    window.navigator
        .getUserMedia(audio: false, video: true
            // video: {
            //   "facingMode": {"exact": "environment"}
            // }
            )
        .then((MediaStream mediaStream) {
      _mediaStream = mediaStream;
      _webcamVideoElement.srcObject = mediaStream;
      // _webcamVideoElement.autoplay = true;
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

  final spinkit = SpinKitCubeGrid(
    color: Colors.white,
    size: 50.0,
  );

  @override
  Widget build(BuildContext context) {
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
                initialData: SCANING_STATE.SCANING,
                builder: (BuildContext context,
                    AsyncSnapshot<SCANING_STATE> snapshot) {
                  if (snapshot.data == SCANING_STATE.SCANING) {
                    return spinkit;
                  }
                  if (snapshot.data == SCANING_STATE.SUCCESS) {
                    return Container();
                  }
                  if (snapshot.data == SCANING_STATE.FAIL) {
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
                  _webcamVideoElement.srcObject.active
                      ? _webcamVideoElement.play()
                      : _webcamVideoElement.pause();
                  if (_webcamVideoElement.srcObject != null) {
                    if (_webcamVideoElement.srcObject.active) {
                      ImageCapture capture = ImageCapture(
                          _webcamVideoElement.srcObject.getVideoTracks().first);
                      Blob blob = await capture.takePhoto();

                      print("Blob capture size 🌁 : ${blob.size}");
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
