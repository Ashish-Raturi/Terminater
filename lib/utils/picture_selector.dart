import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageSelector {
  Future<File> selectImage() async {
    final _picker = ImagePicker();
    PickedFile image;

    image = await _picker.getImage(source: ImageSource.gallery);
    var file = File(image.path);
    if (image != null) {
      return file;
    } else {
      print('***************user don\'t pick any image**********************');
      return null;
    }
  }
}
