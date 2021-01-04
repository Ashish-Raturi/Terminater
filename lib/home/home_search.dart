import 'package:expire_item/home/about%20us.dart';
import 'package:expire_item/home/add_edit.dart';
import 'package:expire_item/home/contact.dart';
import 'package:expire_item/home/homepage.dart';
import 'package:expire_item/home/profile_page.dart';
import 'package:expire_item/models/device_data.dart';
import 'package:expire_item/service/Database/device_database.dart';
import 'package:expire_item/service/auth.dart';
import 'package:expire_item/shared/constant.dart';
import 'package:expire_item/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snappable/snappable.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  String _currentWindow = 'home';
  Widget appBarTitle = new Text(
    "Home",
    style: new TextStyle(color: Colors.white),
  );
  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = new TextEditingController();
  bool _IsSearching;
  String _searchText = "";

  _HomeState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _IsSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _IsSearching = true;
          _searchText = _searchQuery.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _IsSearching = false;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<List<DeviceData>>(
        stream: DeviceDbService(uid: user.uid).getDeviceData,
        builder: (context, snapshot) {
          List<DeviceData> deviceData = snapshot.data;
          if (snapshot.hasData) {
            return new Scaffold(
              backgroundColor: c3,
              key: key,
              drawer: Drawer(
                child: Container(
                  alignment: Alignment.topLeft,
                  color: c1,
                  child: ListView(
                    children: [
                      SizedBox(height: 20.0),
                      Row(
                        children: [
                          SizedBox(
                            width: 20.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: SizedBox(
                                height: 20.0,
                                width: 20.0,
                                child: Image.asset(
                                  'assets/icons/cancel.png',
                                  fit: BoxFit.cover,
                                )),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      ListTile(
                        title: Text('Home',
                            style: TextStyle(
                                color: _currentWindow == 'home'
                                    ? c3
                                    : Colors.white)),
                        leading: Icon(
                          Icons.home,
                          color: _currentWindow == 'home' ? c3 : Colors.white,
                          size: 25.0,
                        ),
                        onTap: () {
                          if (_currentWindow != 'home') {
                            setState(() {
                              _currentWindow = 'home';
                            });
                          }
                          // Navigator.push(context, MaterialPageRoute(builder: (context)=> ))
                        },
                      ),
                      // ListTile(
                      //     title: Text('Expired Item',
                      //         style: TextStyle(
                      //             color: _currentWindow == 'expired item'
                      //                 ? c3
                      //                 : Colors.white)),
                      //     leading: SizedBox(
                      //         height: 25.0,
                      //         width: 25.0,
                      //         child: Image.asset(
                      //           'assets/icons/expire.png',
                      //           fit: BoxFit.cover,
                      //           color: _currentWindow == 'expired item'
                      //               ? c3
                      //               : Colors.white,
                      //         )),
                      //     onTap: () {
                      //       if (_currentWindow != 'expired item') {
                      //         setState(() {
                      //           _currentWindow = 'expired item';
                      //         });
                      //         Navigator.pop(context);
                      //         Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (context) => ExpiredItem()));
                      //       }
                      //     }),
                      ListTile(
                          title: Text('About Us',
                              style: TextStyle(
                                  color: _currentWindow == 'about us'
                                      ? c3
                                      : Colors.white)),
                          leading: SizedBox(
                              height: 22.0,
                              width: 22.0,
                              child: Image.asset(
                                'assets/icons/about us.png',
                                fit: BoxFit.cover,
                                color: _currentWindow == 'about us'
                                    ? c3
                                    : Colors.white,
                              )),
                          onTap: () {
                            if (_currentWindow != 'about us') {
                              setState(() {
                                _currentWindow = 'about us';
                              });
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AboutUs()));
                              setState(() {
                                _currentWindow = 'home';
                              });
                            }
                          }),
                      ListTile(
                          title: Text('Contact',
                              style: TextStyle(
                                  color: _currentWindow == 'contact'
                                      ? c3
                                      : Colors.white)),
                          leading: Icon(Icons.phone,
                              color: _currentWindow == 'contact'
                                  ? c3
                                  : Colors.white,
                              size: 25.0),
                          onTap: () {
                            if (_currentWindow != 'contact') {
                              setState(() {
                                _currentWindow = 'contact';
                              });
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Contact()));
                              setState(() {
                                _currentWindow = 'home';
                              });
                            }
                          }),
                      ListTile(
                          title: Text('Logout',
                              style: TextStyle(
                                  color: _currentWindow == 'logout'
                                      ? c3
                                      : Colors.white)),
                          leading: SizedBox(
                              height: 22.0,
                              width: 22.0,
                              child: Image.asset(
                                'assets/icons/Log out white.png',
                                fit: BoxFit.cover,
                                color: _currentWindow == 'logout'
                                    ? c3
                                    : Colors.white,
                              )),
                          onTap: () {
                            setState(() async {
                              _currentWindow = 'logout';
                              await AuthService().signOut();
                            });
                          }),
                      SizedBox(height: 20.0),

                      Snappable(
                        snapOnTap: true,
                        child: Container(
                            alignment: Alignment.bottomCenter,
                            child: Image.asset('assets/icons/dire.png',
                                fit: BoxFit.cover)),
                      ),
                    ],
                  ),
                ),
              ),
              appBar: buildBar(context),
              body: _IsSearching
                  ? HomePage(deviceData: _buildSearchList(deviceData))
                  : HomePage(deviceData: deviceData),
              floatingActionButton: FloatingActionButton(
                  backgroundColor: c1,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddEditData()))),
            );
          } else {
            return Loading();
          }
        });
  }

  List<DeviceData> _buildSearchList(List<DeviceData> deviceData) {
    if (_searchText.isEmpty) {
      return deviceData;
    } else {
      List<DeviceData> _searchList = List<DeviceData>();
      for (int i = 0; i < deviceData.length; i++) {
        DeviceData data = deviceData.elementAt(i);
        if (data.deviceName.toLowerCase().contains(_searchText.toLowerCase())) {
          _searchList.add(data);
        }
      }
      return _searchList;
    }
  }

  Widget buildBar(BuildContext context) {
    return new AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: c1,
        title: appBarTitle,
        actions: <Widget>[
          new IconButton(
            icon: actionIcon,
            onPressed: () {
              setState(() {
                if (this.actionIcon.icon == Icons.search) {
                  this.actionIcon = new Icon(
                    Icons.close,
                    color: Colors.white,
                  );
                  this.appBarTitle = new TextField(
                    controller: _searchQuery,
                    style: new TextStyle(
                      color: Colors.white,
                    ),
                    decoration: new InputDecoration(
                        prefixIcon: new Icon(Icons.search, color: Colors.white),
                        hintText: "Search...",
                        hintStyle: new TextStyle(color: Colors.white)),
                  );
                  _handleSearchStart();
                } else {
                  _handleSearchEnd();
                }
              });
            },
          ),
          IconButton(
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              })
        ]);
  }

  void _handleSearchStart() {
    setState(() {
      _IsSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        "Home",
        style: new TextStyle(color: Colors.white),
      );
      _IsSearching = false;
      _searchQuery.clear();
    });
  }
}
