import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:washapp/data/model/user.dart';

class UserRepository {

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  Future<User> getById({
    @required String userId
  }) async {
    QuerySnapshot snapshot = await _fireStore.collection('user')
      .where('userId', isEqualTo: userId)
      .get();
    if (snapshot.size > 0) {
      return User(
        userId      : snapshot.docs[0]["userId"],
        userName    : snapshot.docs[0]["email"],
        photoUrl    : snapshot.docs[0]["photoUrl"] ?? '',
        phoneNumber : snapshot.docs[0]["phoneNumber"]
      );
    }
    return null;
  }
}