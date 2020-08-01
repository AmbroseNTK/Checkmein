import 'dart:convert';
import 'dart:html';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:checkmein/resources.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _webcamVideoElement = VideoElement();

    ui.platformViewRegistry.registerViewFactory(
        'webcamVideoElement', (int viewId) => _webcamVideoElement);

    _webcamWidget =
        HtmlElementView(key: UniqueKey(), viewType: 'webcamVideoElement');

    window.navigator.getUserMedia(audio: false,
        // video: true
        video: {
          // "facingMode": {"exact": "environment"}
        }).then((MediaStream mediaStream) {
      _mediaStream = mediaStream;
      _webcamVideoElement.srcObject = mediaStream;
      // _webcamVideoElement.autoplay = true;
      // if (_webcamVideoElement.srcObject.active) {
      //   _webcamVideoElement.play();
      // }
    });
  }

  Future<void> callQRDecodeAPI(Blob imgFile) async {
    String qrDecodeEndPoint = "https://api.qrserver.com/v1/read-qr-code/";
    FileReader reader = FileReader();
    // print(Url.createObjectUrlFromBlob(imgFile));
    reader.readAsArrayBuffer(imgFile);

    // Listen on event [BLOB] loaded into FileReade and then send it to QR DECODE API
    await reader.onLoadEnd.firstWhere((element) => element.loaded > 0);
    try {
      dio.FormData formData = new dio.FormData.fromMap({
        'file': new dio.MultipartFile.fromBytes(reader.result,
            filename: "capture.png", contentType: new MediaType("image", "png"))
      });
      var respone =  await new dio.Dio().post(qrDecodeEndPoint,
          data: formData,
          options: dio.Options(
            contentType: 'multipart/form-data',
          ));
      if (respone.statusCode == 200) {
        print(respone.data);
      }
    } catch (e) {
      print(e);
    }
  }

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
              child: _webcamWidget,
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
                      print(blob);

                      // FileSystem _filesystem = await window
                      //     .requestFileSystem(1024 * 1024, persistent: false);
                      // FileEntry fileEntry =
                      //     await _filesystem.root.createFile('capture.png');
                      // FileWriter fw = await fileEntry.createWriter();
                      // fw.write(blob);
                      // var file = await fileEntry.file();
                      // FileReader reader = FileReader();
                      // reader.readAsArrayBuffer(blob);
                      // print(reader.result.toString());

                      await callQRDecodeAPI(blob);
                      // print("Done");
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
