import 'package:firebase_database/firebase_database.dart';

class HomeRepository {
  final DatabaseReference _database =
  FirebaseDatabase.instance.ref();

  Future<String> getUserName(String uid) async {
    final snapshot = await _database
        .child('users')
        .child(uid)
        .child('name')
        .get();

    if (snapshot.exists) {
      return snapshot.value.toString();
    }

    return 'User';
  }
}