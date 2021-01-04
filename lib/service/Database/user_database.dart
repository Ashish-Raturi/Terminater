import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expire_item/models/user_data.dart';

class UserDbService {
  String uid;

  UserDbService({this.uid});

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //User Data
  // add & update
  Future addUserData(String mailId, String name, String password,
      String mobileno, String location) async {
    await _firestore.collection(uid).doc('User Data').set({
      'Email Id': mailId,
      'Name': name,
      'Password': password,
      'Mobile No': mobileno,
      'Location': location
    });
  }

  // get user data steam
  Stream<AppUserData> get getUserData {
    return _firestore
        .collection(uid)
        .doc('User Data')
        .snapshots()
        .map(pimUserDataFormSnapshot);
  }

  // get pim User List Form Snapshot
  AppUserData pimUserDataFormSnapshot(DocumentSnapshot snapshot) {
    return AppUserData(
      email: snapshot.get('Email Id') ?? '',
      name: snapshot.get('Name') ?? '',
      password: snapshot.get('Password') ?? '',
      mobile: snapshot.get('Mobile No') ?? '',
      location: snapshot.get('Location') ?? '',
    );
  }
}
