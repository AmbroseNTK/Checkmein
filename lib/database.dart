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
    print("Get events");
    var user = await _firebaseAuthService.firebaseAuth.currentUser();
    print(user.uid);
    var snapshot =
        await _firestore.collection('users').document(user.uid).get();
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
    var getUid = await _firebaseAuthService.firebaseAuth.currentUser();
    await _firestore.collection("events").add({
      "ownerId": getUid.uid,
      "name": event.name,
      "location": event.location,
      "duration": event.duration,
      "startDay": event.startDay
    });
  }
}
