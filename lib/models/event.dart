import 'package:checkmein/models/user.dart';

class Event {
  String _eventId;
  String _name;
  String _location;
  int _startDay;
  int _duration = 0;
  List<User> _participants;
  Event(
      {String eventId,
      String name,
      String location,
      int startDay,
      int duration,
      List<User> participants}) {
    this._eventId = eventId;
    this._name = name;
    this._location = location;
    this._startDay = startDay;
    this._duration = duration;
    this._participants = participants;
  }
  String get eventId => _eventId;
  String get name => _name;
  String get location => _location;
  int get startDay => _startDay;
  int get duration => _duration;
  List<User> get participants => _participants;
}
