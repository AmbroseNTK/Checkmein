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
  Future<void> getEvents() async {
    print("Get events");
    var user = await _firebaseAuthService.firebaseAuth.currentUser();
    print(user.uid);
    var snapshot =
        await _firestore.collection('users').document(user.uid).get();
  }

  Database._internal() {
    _firebaseAuthService = FirebaseAuthService();
    //_firestore = _firebaseAuthService.firestore;
  }
}
