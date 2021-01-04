import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expire_item/models/device_data.dart';
import 'package:expire_item/service/storage/storage.dart';

class DeviceDbService {
  String uid;

  DeviceDbService({this.uid});

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // add & update
  Future addUserData(CloudStorageResult result, String buyingDate,
      String expireDate, String description) async {
    await _firestore
        .collection(uid)
        .doc('Device')
        .collection('Device Data')
        .doc()
        .set({
      'Device Name': result.imageFileName,
      'Buying Date': buyingDate,
      'Expeiry Date': expireDate,
      'Device Image Url': result.deviceImageUrl,
      'Bill Image Url': result.billImageUrl,
      'Description': description
    });
  }

  //Delete
  Future deleteData(String id) async {
    await _firestore
        .collection(uid)
        .doc('Device')
        .collection('Device Data')
        .doc(id)
        .delete()
        .whenComplete(() => print('file deleted'));
  }

  // get user data steam
  Stream<List<DeviceData>> get getDeviceData {
    return _firestore
        .collection(uid)
        .doc('Device')
        .collection('Device Data')
        .snapshots()
        .map(pimUserDataFormSnapshot);
  }

  // get pim User List Form Snapshot
  List<DeviceData> pimUserDataFormSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) => DeviceData(
            docId: doc.id,
            billImageUrl: doc.get('Bill Image Url'),
            buyingDate: doc.get('Buying Date'),
            description: doc.get('Description'),
            deviceImageUrl: doc.get('Device Image Url'),
            deviceName: doc.get('Device Name'),
            expeiryDate: doc.get('Expeiry Date')))
        .toList();
  }
}
