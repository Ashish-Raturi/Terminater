import 'package:expire_item/home/image_view.dart';
import 'package:expire_item/models/device_data.dart';
import 'package:expire_item/service/storage/storage.dart';
import 'package:expire_item/shared/constant.dart';
import 'package:expire_item/shared/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatefulWidget {
  final DeviceData deviceData;
  final String timeLeft;
  final String name;
  final int dayLeft;
  const DetailPage({
    Key key,
    this.deviceData,
    this.timeLeft,
    this.dayLeft,
    this.name,
  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<String> choices = ['View Image', 'Download Images', 'Delete'];
  bool showImage;
  int _currentIndex = 0;
  PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      initialPage: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> _networkImage = [
      widget.deviceData.deviceImageUrl,
      widget.deviceData.billImageUrl
    ];

    final user = Provider.of<User>(context);

    _downloadImage(String image) async {
      try {
        // Saved with this method.

        var imageId = await ImageDownloader.downloadImage(image);
        if (imageId == null) {
          return null;
        }

        // Below is a method of obtaining saved image information.
        var fileName = '${widget.deviceData.deviceName}(Device Photo)';

        var path = await ImageDownloader.findPath(imageId);
        // var size = await ImageDownloader.findByteSize(imageId);
        // var mimeType = await ImageDownloader.findMimeType(imageId);

        print(fileName);
        return path;
      } on PlatformException catch (error) {
        print(error);
        return null;
      }
    }

    return Scaffold(
      backgroundColor: c1,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder:
              (BuildContext context, bool innnerBoxInScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: c1,
                expandedHeight: 300.0,
                iconTheme: IconThemeData(
                  color: Colors.white,
                ),
                actions: [
                  PopupMenuButton<String>(
                    onCanceled: () {
                      print('You have not chossed anything');
                    },
                    onSelected: (val) async {
                      if (val == 'Delete') {
                        await CloudStorageService(uid: user.uid).deleteImage(
                            name: widget.deviceData.deviceName,
                            id: widget.deviceData.docId,
                            billImage: _networkImage[1] != null ? true : false,
                            deviceImage:
                                _networkImage[0] != null ? true : false);
                        Navigator.pop(context);

                        showToast(
                          'Deleted Sucessfuly',
                          context,
                        );
                      } else if (val == 'View Image') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImageView(
                                      networkImage: _networkImage,
                                    )));
                      } else if (val == 'Download Images') {
                        showToast('Downloading Images...', context,
                            showTick: false);
                        for (int i = 0; i < 2; i++) {
                          String image;
                          if (i == 0) {
                            image = widget.deviceData.deviceImageUrl;
                          } else {
                            image = widget.deviceData.billImageUrl;
                          }
                          if (image == null) {
                            continue;
                          }

                          _downloadImage(image).then((value) {
                            if (value != null) {
                              showToast(
                                  'Downloading Complete, path:~$value', context,
                                  showTick: false);
                            } else {
                              showToast(
                                  'Some error occur, Please try again', context,
                                  error: true);
                            }
                          });
                        }
                      }
                    },
                    itemBuilder: (context) {
                      return choices
                          .map((choice) => PopupMenuItem<String>(
                              value: choice, child: Text(choice)))
                          .toList();
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  background: Stack(
                    children: [
                      PageView.builder(
                          onPageChanged: (value) {
                            setState(() {
                              _currentIndex = value;
                            });
                          },
                          itemCount: 2,
                          controller: _controller,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ImageView(
                                              networkImage: _networkImage,
                                              deviceName:
                                                  widget.deviceData.deviceName,
                                            ))),
                                child: widget.deviceData.deviceImageUrl != null
                                    ? Image.network(
                                        widget.deviceData.deviceImageUrl,
                                        fit: BoxFit.contain,
                                      )
                                    : Image.asset(
                                        'assets/icons/Default_Device.png'),
                              );
                            } else {
                              return GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ImageView(
                                              networkImage: _networkImage,
                                              deviceName:
                                                  widget.deviceData.deviceName,
                                            ))),
                                child: widget.deviceData.billImageUrl != null
                                    ? Image.network(
                                        widget.deviceData.billImageUrl,
                                        fit: BoxFit.contain,
                                      )
                                    : Image.asset(
                                        'assets/icons/Default_bill.png'),
                              );
                            }
                          }),
                      //Next Button

                      Positioned.fill(
                        right: 15.0,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                              child: Image.asset('assets/icons/next.png',
                                  color: _currentIndex == 0 ? c3 : c2,
                                  width: 30.0,
                                  height: 30.0,
                                  fit: BoxFit.contain),
                              onTap: () {
                                _controller.nextPage(
                                  duration: const Duration(milliseconds: 100),
                                  curve: Curves.linearToEaseOut,
                                );
                              }),
                        ),
                      ),
                      //
                      //Previous Button
                      Positioned.fill(
                        left: 15.0,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                              child: Image.asset('assets/icons/pre.png',
                                  color: _currentIndex == 1 ? c3 : c2,
                                  width: 30.0,
                                  height: 30.0,
                                  fit: BoxFit.contain),
                              onTap: () {
                                _controller.previousPage(
                                  duration: const Duration(milliseconds: 100),
                                  curve: Curves.linearToEaseOut,
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
                // flexibleSpace: FlexibleSpaceBar(
                //   centerTitle: true,
                //   background: Swiper(
                //       itemCount: 2,
                //       onTap: (i) {
                //         Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => ImageView(
                //                       networkImage: _networkImage,
                //                       deviceName: widget.deviceData.deviceName,
                //                     )));
                //       },
                //       // pagination: SwiperPagination(
                //       //     alignment: Alignment.bottomCenter,
                //       //     builder: DotSwiperPaginationBuilder(
                //       //       color: Colors.white,
                //       //       activeColor: c1,
                //       //     )),
                //       control: SwiperControl(
                //           color: Colors.white,
                //           size: 24.0,
                //           padding: EdgeInsets.only(left: 20.0, right: 20.0)),
                //       itemBuilder: (BuildContext context, int index) {
                //         if (index == 0) {
                //           return widget.deviceData.deviceImageUrl != null
                //               ? Image.network(
                //                   widget.deviceData.deviceImageUrl,
                //                   fit: BoxFit.contain,
                //                 )
                //               : Image.asset('assets/icons/Default_Device.png');
                //         } else {
                //           return widget.deviceData.billImageUrl != null
                //               ? Image.network(
                //                   widget.deviceData.billImageUrl,
                //                   fit: BoxFit.contain,
                //                 )
                //               : Image.asset('assets/icons/Default_bill.png');
                //         }
                //       }),
                // ),
              ),
            ];
          },
          body: Stack(children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(widget.name.toUpperCase(),
                      style: TextStyle(color: c3, fontSize: 30.0)),
                  Divider(
                    thickness: 3.0,
                    color: c3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('BUYING DATE',
                          style: TextStyle(color: c3, fontSize: 20.0)),
                      Text('EXPIRY DATE',
                          style: TextStyle(color: c3, fontSize: 20.0))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                          DateFormat.yMMMEd()
                              .format(
                                  DateTime.parse(widget.deviceData.buyingDate))
                              .toString(),
                          style: TextStyle(color: c2, fontSize: 15.0)),
                      Text(
                          DateFormat.yMMMEd()
                              .format(
                                  DateTime.parse(widget.deviceData.expeiryDate))
                              .toString(),
                          style: TextStyle(color: c2, fontSize: 15.0)),
                    ],
                  ),
                  Text('TIME LEFT \t:\t ${widget.timeLeft} ',
                      style: TextStyle(
                          color:
                              widget.dayLeft <= 0 ? Colors.red : Colors.green,
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0)),
                  Divider(
                    thickness: 3.0,
                    color: c3,
                  ),
                  if (widget.deviceData.description != null)
                    Text('DESCRIPTION',
                        style: TextStyle(color: c3, fontSize: 20.0)),
                  if (widget.deviceData.description != null)
                    Text('${widget.deviceData.description}',
                        style: TextStyle(color: Colors.white, fontSize: 15.0))
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
