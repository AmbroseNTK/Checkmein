import 'dart:html';
import 'dart:math';

import 'package:checkmein/models/event.dart';
import 'package:checkmein/models/user.dart';
import 'package:checkmein/signin_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<void> saveEvent(Event event) async {
    var usr = await _firebaseAuthService.firebaseAuth.currentUser();
    var user = new User(
        checkinTime: DateTime.now().millisecondsSinceEpoch,
        email: usr.email,
        displayName: usr.displayName,
        photoURL: usr.photoUrl,
        uid: null);
    var ref = await _firestore.collection("events").add({
      "ownerId": usr.uid,
      "name": event.name,
      "location": event.location,
      "duration": event.duration,
      "startDay": event.startDay,
    });
    await _firestore.collection("users").document(usr.uid).updateData({
      "events": FieldValue.arrayUnion([ref.documentID])
    });
    await ref.collection("participants").add({
      "checkinTime": user.checkinTime,
      "displayName": user.displayName,
      "photoURL": user.photoURL,
      "email": user.email
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

  String qrDataGenerator() {
    String data;
    var characters =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    Random random = Random.secure();
    String.fromCharCodes(Iterable.generate(characters.length,
        (_) => characters.codeUnitAt(random.nextInt(characters.length))));
    return data;
  }
}
