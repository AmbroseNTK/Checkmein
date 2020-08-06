import 'package:checkmein/models/user.dart';

class Event {
  String _eventId;
  String _name;
  String _location;
  int _startDay;
  int _duration = 0;
  List<User> _participants;
  String _eventQR;
  Event(
      {String eventId,
      String name,
      String location,
      int startDay,
      int duration,
      List<User> participants,String eventQR}) {
    this._eventId = eventId;
    this._name = name;
    this._location = location;
    this._startDay = startDay;
    this._duration = duration;
    this._participants = participants;
    this._eventQR = eventQR;
  }

  Event.fromJson(Map<String, dynamic> json) {
    this._eventId = json['eventId'];
    this._name = json['name'];
    this._location = json['location'];
    this._duration = json['duration'];
    this._startDay = json['startDay'];
    this._eventQR = json['eventQR'];
  }
  String get eventId => _eventId;
  String get name => _name;
  String get location => _location;
  int get startDay => _startDay;
  int get duration => _duration;
  List<User> get participants => _participants;
  String get eventQR => this._eventQR;
}
