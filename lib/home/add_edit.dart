import 'dart:io';
import 'package:expire_item/service/Database/device_database.dart';
import 'package:expire_item/shared/constant.dart';
import 'package:expire_item/shared/loading.dart';
import 'package:expire_item/shared/toast.dart';
import 'package:expire_item/utils/picture_selector.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:expire_item/service/storage/storage.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddEditData extends StatefulWidget {
  @override
  _AddEditDataState createState() => _AddEditDataState();
}

class _AddEditDataState extends State<AddEditData> {
  final _formkey = GlobalKey<FormState>();
  DateTime _buyingDate = DateTime.now();
  DateTime _expiryDate = DateTime.now();
  String _deviceName;
  String _description;
  File _deviceImageFile;
  File _billImageFile;
  bool _showLoading = false;
  //DatePicker
  Future<DateTime> _selectDate(DateTime currentDate) async {
    DateTime _pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime.now().subtract(Duration(days: 365 * 10)),
        lastDate: DateTime.now().add(Duration(days: 365 * 10)));

    if (_pickedDate != null) {
      return _pickedDate;
    } else {
      return currentDate;
    }
  }

  //assets path into File
  // Future<File> getImageFileFromAssets(String path) async {
  //   final byteData = await rootBundle.load('assets/$path');

  //   final file = File('${(await getTemporaryDirectory()).path}/$path');
  //   await file.writeAsBytes(byteData.buffer
  //       .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  //   return file;
  // }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return _showLoading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.white),
                backgroundColor: c1,
                title:
                    Text('Add Device', style: TextStyle(color: Colors.white))),
            body: SafeArea(
                child: SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.all(30.0),
                  child: Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          TextFormField(
                            cursorColor: c1,
                            decoration: additemtextInputDecoration.copyWith(
                                hintText: 'Device Name'),
                            validator: (val) =>
                                val.isEmpty ? 'Enter Device Name' : null,
                            onChanged: (value) {
                              setState(() {
                                _deviceName = value;
                              });
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                  onTap: () async {
                                    var tempFile =
                                        await ImageSelector().selectImage();
                                    if (tempFile != null) {
                                      setState(() {
                                        _deviceImageFile = tempFile;
                                      });
                                    } else {
                                      print('no path returned');
                                    }
                                  },
                                  child: SizedBox(
                                    height: 150.0,
                                    width: 140.0,
                                    child: (_deviceImageFile != null)
                                        ? Image.file(_deviceImageFile)
                                        : Container(
                                            alignment: Alignment.center,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.plus,
                                                  size: 40.0,
                                                ),
                                                Text(
                                                  'Device Image',
                                                  style:
                                                      TextStyle(fontSize: 20.0),
                                                ),
                                              ],
                                            ),
                                            color: c2,
                                          ),
                                  )),
                              SizedBox(
                                height: 20.0,
                              ),
                              GestureDetector(
                                  onTap: () async {
                                    var tempFile =
                                        await ImageSelector().selectImage();
                                    if (tempFile != null) {
                                      setState(() {
                                        _billImageFile = tempFile;
                                      });
                                    } else {
                                      print('no path returned');
                                    }
                                  },
                                  child: SizedBox(
                                    height: 150.0,
                                    width: 140.0,
                                    child: (_billImageFile != null)
                                        ? Image.file(_billImageFile)
                                        : Container(
                                            alignment: Alignment.center,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.plus,
                                                  size: 40.0,
                                                ),
                                                Text(
                                                  'Bill Image',
                                                  style:
                                                      TextStyle(fontSize: 20.0),
                                                ),
                                              ],
                                            ),
                                            color: c2,
                                          ),
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Text('Buying Date',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1.0))),
                              Expanded(
                                flex: 2,
                                child: //DropDown
                                    FlatButton(
                                  padding: EdgeInsets.all(0.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: 22.0,
                                      ),
                                      SizedBox(
                                        width: 16.0,
                                      ),
                                      Text(DateFormat.yMMMEd()
                                          .format(_buyingDate)),
                                      Icon(
                                        Icons.arrow_drop_down,
                                      )
                                    ],
                                  ),
                                  onPressed: () async {
                                    DateTime pickedDate =
                                        await _selectDate(_buyingDate);
                                    setState(() {
                                      _buyingDate = pickedDate;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Text('Expiry Date',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1.0))),
                              Expanded(
                                flex: 2,
                                child: //DropDown
                                    FlatButton(
                                  padding: EdgeInsets.all(0.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: 22.0,
                                      ),
                                      SizedBox(
                                        width: 16.0,
                                      ),
                                      Text(DateFormat.yMMMEd()
                                          .format(_expiryDate)),
                                      Icon(
                                        Icons.arrow_drop_down,
                                      )
                                    ],
                                  ),
                                  onPressed: () async {
                                    DateTime pickedDate =
                                        await _selectDate(_expiryDate);
                                    setState(() {
                                      _expiryDate = pickedDate;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            cursorColor: c1,
                            maxLines: 3,
                            decoration: additemtextInputDecoration.copyWith(
                                hintText: 'Description...'),
                            onChanged: (val) {
                              setState(() {
                                _description = val;
                              });
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                        ],
                      ))),
            )),
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: c1,
              label: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
              icon: Image.asset(
                'assets/icons/save.png',
                height: 20.0,
                width: 20.0,
                color: Colors.white,
              ),
              onPressed: () async {
                if (_formkey.currentState.validate()) {
                  setState(() {
                    _showLoading = true;
                  });

                  CloudStorageResult result =
                      await CloudStorageService(uid: user.uid).uploadImage(
                    deviceFile: _deviceImageFile,
                    billFile: _billImageFile,
                    title: _deviceName,
                  );
                  if (result != null) {
                    DeviceDbService(uid: user.uid).addUserData(
                        result,
                        _buyingDate.toString(),
                        _expiryDate.toString(),
                        _description);

                    showToast('Item Added Sucessfully', context);

                    print('file uploded sucessfully');

                    Navigator.pop(context);
                  } else {
                    showToast('Some error occur, Please try again', context,
                        error: true);
                    setState(() {
                      _showLoading = false;
                    });
                  }
                }
              },
            ));
  }

//   uploadImage() async {
//     final _storage = FirebaseStorage.instance;
//     final _picker = ImagePicker();

//     PickedFile image;
//     //check permission
//     await Permission.photos.request();

//     var permissionStatus = await Permission.photos.status;
//     if (permissionStatus.isGranted) {
// //select image
//       image = await _picker.getImage(source: ImageSource.gallery);
//       var file = File(image.path);
//       if (image != null) {
//         // upload to firebase
//         var snapshot = await _storage
//             .ref()
//             .child('foldername/imagename')
//             .putFile(file)
//             .onComplete;

//         var downloadUrl = await snapshot.ref.getDownloadURL();
//         setState(() {
//           imageUrl = downloadUrl;
//         });
//       } else {
//         print('No Path Received');
//       }
//     } else {
//       print('Grant Permissions and try again');
//     }
//   }
}
