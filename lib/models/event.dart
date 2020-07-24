class Event {
  String _eventId;
  String _name;
  String _location;
  String _startDay;
  int _duration = 0;
  Event(
      {String eventId,
      String name,
      String location,
      String startDay,
      int duration}) {
    this._eventId = eventId;
    this._name = name;
    this._location = location;
    this._startDay = startDay;
    this._duration = duration;
  }
}
