import 'dart:io';
import 'package:expire_item/service/Database/device_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CloudStorageService {
  String uid;
  CloudStorageService({this.uid});

  Future<CloudStorageResult> uploadImage({
    File deviceFile,
    File billFile,
    String title,
  }) async {
    var imageFileName =
        title + '#' + DateTime.now().millisecondsSinceEpoch.toString();
    //Add Device Image Url
    firebase_storage.UploadTask task;
    if (deviceFile != null) {
      task = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('$uid/$imageFileName/device')
          .putFile(deviceFile);
    }
    //Add Bill Image Url
    firebase_storage.UploadTask task2;
    if (billFile != null) {
      task2 = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('$uid/$imageFileName/bill')
          .putFile(billFile);
    }
    try {
      //Getting Device Image Url
      String deviceImageUrl;
      if (task != null) {
        firebase_storage.TaskSnapshot snapshot = await task;
        deviceImageUrl = await snapshot.ref.getDownloadURL();
      }
      //Getting Bill Image Url
      String billImageUrl;
      if (task2 != null) {
        firebase_storage.TaskSnapshot snapshot2 = await task2;
        billImageUrl = await snapshot2.ref.getDownloadURL();
      }

      print('Image uploded $deviceImageUrl,');
      return CloudStorageResult(
        deviceImageUrl: deviceImageUrl,
        billImageUrl: billImageUrl,
        imageFileName: imageFileName,
      );
    } on firebase_storage.FirebaseException {
      // e.g, e.code == 'canceled'
      // The final snapshot is also available on the task via `.snapshot`,
      // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
      print(task.snapshot);
      return null;
    }
  }

  Future deleteImage(
      {String name, String id, bool deviceImage, bool billImage}) async {
    var instance = firebase_storage.FirebaseStorage.instance;
    if (name != null) {
      if (deviceImage == true && billImage == true) {
        var ref = instance.ref('$uid/$name/device');
        var ref2 = instance.ref('$uid/$name/bill');
        await ref.delete();
        await ref2.delete();
      } else if (deviceImage == true && billImage == false) {
        var ref = instance.ref('$uid/$name/device');
        await ref.delete();
      } else if (deviceImage == false && billImage == true) {
        var ref2 = instance.ref('$uid/$name/bill');
        await ref2.delete();
      }
      await DeviceDbService(uid: uid).deleteData(id);
      print('deleted sucessfully');
    } else {
      print('device name is null');
    }
  }
}

class CloudStorageResult {
  final String deviceImageUrl;
  final String billImageUrl;
  final String imageFileName;

  CloudStorageResult(
      {this.deviceImageUrl, this.billImageUrl, this.imageFileName});
}
