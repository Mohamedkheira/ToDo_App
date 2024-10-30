import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageHandler {
  static Future<String> uploadUserPhoto(XFile photo) async {
    var storageRef = FirebaseStorage.instance.ref();
    var photoRef = storageRef.child(photo.path);
    var uploadTask = photoRef.putFile(File(photo.path));
    var taskSnapshot = await uploadTask.whenComplete(() => null);
    String photoLink = await photoRef.getDownloadURL();
    return photoLink;
  }
}
