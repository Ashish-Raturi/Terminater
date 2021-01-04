import 'package:expire_item/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageView extends StatefulWidget {
  final List<String> networkImage;
  final String deviceName;
  ImageView({this.networkImage, this.deviceName});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        body: Container(
            child: PhotoViewGallery.builder(
          scrollDirection: Axis.horizontal,
          enableRotation: true,
          gaplessPlayback: true,
          loadFailedChild: Center(
              child: Icon(
            FontAwesomeIcons.photoVideo,
            size: 120.0,
          )),
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              tightMode: true,
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: 4.0,
              imageProvider: widget.networkImage[index] != null
                  ? NetworkImage(widget.networkImage[index])
                  : AssetImage(
                      index == 0 ? 'Default_Device.png' : 'Default_bill.png'),
              initialScale: PhotoViewComputedScale.contained * 0.8,
            );
          },
          itemCount: widget.networkImage.length,
          loadingBuilder: (context, event) => Center(
            child: Container(
              width: 50.0,
              height: 50.0,
              child: CircularProgressIndicator(
                backgroundColor: c2,
                value: event == null
                    ? 0
                    : event.cumulativeBytesLoaded / event.expectedTotalBytes,
              ),
            ),
          ),
        )));
  }
}
