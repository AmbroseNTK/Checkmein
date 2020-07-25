class User {
  String _uid;
  String _email;
  String _displayName;
  String _photoURL;
  int _checkinTime;

  User(
      {String uid,
      String email,
      String displayName,
      String photoURL,
      int checkinTime}) {
    this._uid = uid;
    this._email = email;
    this._displayName = displayName;
    this._photoURL = photoURL;
    this._checkinTime = checkinTime;
  }

  String get uid => _uid;
  String get email => _email;
  String get displayName => _displayName;
  String get photoURL => _photoURL;
  int get checkinTime => _checkinTime;
}
