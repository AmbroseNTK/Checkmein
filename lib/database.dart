import 'dart:html' as html;
import 'dart:math';

import 'package:checkmein/models/event.dart';
import 'package:checkmein/models/user.dart';
import 'package:checkmein/signin_service.dart';
import 'package:checkmein/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart' as dio;

class Database {
  Firestore _firestore = Firestore.instance;
  FirebaseAuthService _firebaseAuthService;
  static Database _cache;
  factory Database() {
    if (_cache == null) {
      _cache = Database._internal();
    }
    return _cache;
  }

  /// TODO IMPLEMENT CACHING
  Future<List<Event>> getEvents() async {
    List<Event> listEvents = List();
    var user = await _firebaseAuthService.firebaseAuth.currentUser();
    var snapshot =
        await _firestore.collection('users').document(user.uid).get();
    // _firestore.collection('users').document(user.uid).snapshots().listen((event) {

    // })
    try {
      if (snapshot.exists) {
        var eventIds = snapshot.data["events"] as List<dynamic>;
        for (var i = 0; i < eventIds.length; i++) {
          var event = await getEventById(eventIds[i]);
          var participants = await getParticipantsByEventId(eventIds[i]);
          if (event != null) {
            listEvents.add(Event(
                eventId: eventIds[i],
                name: event["name"],
                location: event["location"],
                duration: event["duration"],
                startDay: event["startDay"],
                eventQR: event["eventQR"],
                participants: participants));
          }
        }
      }
    } catch (e) {
      return null;
    }
    return listEvents;
  }

  Future<Map<String, dynamic>> getEventById(String eventId) async {
    var eventInfo =
        await _firestore.collection("events").document(eventId).get();
    if (eventInfo.exists) {
      return eventInfo.data;
    }
    return null;
  }

  Future<List<User>> getParticipantsByEventId(String eventId) async {
    var result = List<User>();
    try {
      var participants = await _firestore
          .collection("events")
          .document(eventId)
          .collection("participants")
          .getDocuments();
      for (var i = 0; i < participants.documents.length; i++) {
        var userInfo = participants.documents[i];
        if (userInfo.exists) {
          result.add(new User(
              uid: userInfo.documentID,
              displayName: userInfo.data["displayName"],
              email: userInfo.data["email"],
              photoURL: userInfo.data["photoURL"],
              checkinTime: userInfo.data["checkinTime"]));
        }
      }
    } catch (e) {
      return null;
    }
    return result;
  }

  Database._internal() {
    _firebaseAuthService = FirebaseAuthService();
    //_firestore = _firebaseAuthService.firestore;
  }

  Future<User> getUserInfoCurrentTime() async {}

  Future<void> saveEvent(Event event) async {
    var usr = await _firebaseAuthService.firebaseAuth.currentUser();
    var ref = await _firestore.collection("events").add({
      "ownerId": usr.uid,
      "name": event.name,
      "location": event.location,
      "duration": event.duration,
      "startDay": event.startDay,
      // "eventQR":eventQRCode
    });

    // Hmmmm after add to Firestore return a Ref to document use that to make a QR code 😅
    var updateEventRefWithQRCode = await _firestore
        .collection("events")
        .document(ref.documentID)
        .setData({"eventQR": ref.documentID}, merge: true);

    await addToEnteredEvent(usr.uid, ref.documentID);
  }

  Future<void> addToEnteredEvent(String userUUID, String eventRef) async {
    // Add user Entered Event to there LIST[]
    await _firestore.collection("users").document(userUUID).updateData({
      "events": FieldValue.arrayUnion([eventRef])
    });
  }

  Future<void> saveUsers(User user) async {
    var usr = await _firebaseAuthService.firebaseAuth.currentUser();
    var userInfo = await _firestore.collection("users").document(usr.uid).get();
    print("User info: " + userInfo.documentID);
    if (userInfo.exists) {
      print("Already exists");
      return;
    } else {
      await _firestore
          .collection("users")
          .document(user.uid)
          .setData({"events": []});
    }
  }

  Future<void> deleteEvent(String eventId) async {
    var usr = await _firebaseAuthService.firebaseAuth.currentUser();
    var refEventFromUser =
        await _firestore.collection("users").document(usr.uid).get();

    // get all events of user
    List items = List();
    for (var item in refEventFromUser.data.values) {
      for (var i in item) {
        items.add(i);
      }
    }

    for (var i = 0; i < items.length; i++) {
      if (eventId == items[i]) {
        await _firestore.collection("events").document(eventId).delete();
        await _firestore
            .collection("events")
            .document(eventId)
            .collection("participants")
            .getDocuments()
            .then((value) {
          for (DocumentSnapshot ds in value.documents) {
            ds.reference.delete();
          }
        });
        await _firestore.collection("users").document(usr.uid).updateData({
          "events": FieldValue.arrayRemove([items[i]])
        });
      } else {}
    }
  }

  Future<void> updateEvent(String eventId, Event event) async {
    print("from db id: " + eventId);
    print(event.duration);
    print(event.name);
    try {
      await _firestore.collection("events").document(eventId).updateData({
        "duration": event.duration,
        "location": event.location,
        "name": event.name,
        "startDay": event.startDay
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteParticipantsByEventId(String eventId) async {
    try {
      await _firestore
          .collection("events")
          .document(eventId)
          .collection("participants")
          .document()
          .delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> createRoomQRCode(
      {DocumentReference eventRef, String eventQR}) async {
    var roomQRRef = await _firestore
        .collection("roomQR")
        .document(eventQR)
        .setData({"eventID": eventRef.path});
  }

  Future<ENTER_EVENT_STATE> addUserToEvent(String eventRef) async {
    var firebaseusr = await _firebaseAuthService.firebaseAuth.currentUser();
    var user = new User(
        checkinTime: DateTime.now().millisecondsSinceEpoch,
        email: firebaseusr.email,
        displayName: firebaseusr.displayName,
        photoURL: firebaseusr.photoUrl,
        uid: null);

    var eventRefInfo =
        await _firestore.collection("events").document(eventRef).get();
    if (eventRefInfo.exists) {
      var userParticipantsRef = _firestore
          .collection("events")
          .document(eventRef) // UUID of EVENT
          .collection("participants")
          .document(firebaseusr.uid);

      // Finding  user already signed to the EVENT
      var existsEntering = await userParticipantsRef.get();

      if (existsEntering.exists) {
        // EXITES USER in the EVENT
        return ENTER_EVENT_STATE.EXISTED;
      } else {
        await userParticipantsRef.setData(user.toJson());
        await addToEnteredEvent(firebaseusr.uid, eventRef);
        return ENTER_EVENT_STATE.NEW;
      }
    }
    return ENTER_EVENT_STATE.ERROR; // STAND FOR EVENT ID NOT FOUND
  }

  Future<Event> getEventInfo(String eventRef) async {
    // Function getting Single Event
    var querydata =
        await _firestore.collection("events").document(eventRef).get();
    if (querydata.exists) {
      return Event.fromJson(querydata.data);
    }
    return null;
  }

  static Future<String> callQRDecodeAPI(html.Blob imgFile) async {
    String qrDecodeEndPoint = "https://api.qrserver.com/v1/read-qr-code/";
    RegExp qrCodeResult = new RegExp("[\n\s]*data:[\n\s]*(.*)[\n\s]*\,[\n\s]*",
        caseSensitive: false);

    html.FileReader reader = html.FileReader();
    // print(Url.createObjectUrlFromBlob(imgFile));
    reader.readAsArrayBuffer(imgFile);

    // Listen on event [BLOB] loaded into FileReade and then send it to QR DECODE API
    await reader.onLoadEnd.firstWhere((element) => element.loaded > 0);
    try {
      dio.FormData formData = new dio.FormData.fromMap({
        'file': new dio.MultipartFile.fromBytes(reader.result,
            filename: "capture.png", contentType: new MediaType("image", "png"))
      });
      var respone = await new dio.Dio().post(qrDecodeEndPoint,
          data: formData,
          options: dio.Options(
            contentType: 'multipart/form-data',
          ));
      if (respone.statusCode == 200) {
        print(respone.data);
        print(respone.data.runtimeType);

        // Hmm casting result
        String decodeResult = (respone.data as List<dynamic>).join();
        String parseData =
            qrCodeResult.stringMatch(decodeResult).split(" ")[1].split(",")[0];
        print(parseData);
        return parseData;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
    }
  }
}
