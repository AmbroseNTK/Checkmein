class User {
  String _uid;
  String _email;
  String _displayName;
  String _photoURL;

  User({String uid, String email, String displayName, String photoURL}) {
    this._uid = uid;
    this._email = email;
    this._displayName = displayName;
    this._photoURL = photoURL;
  }

  String get uid => _uid;
  String get email => _email;
  String get displayName => _displayName;
  String get photoURL => _photoURL;
}
