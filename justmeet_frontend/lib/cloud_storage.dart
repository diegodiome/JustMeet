import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorage {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  String saveFile(File file) {
    try {
      StorageReference storageReference = firebaseStorage.ref();
      String storagePath = '/events_images/' +
          Random().nextInt(10000).toString() +
          '.' +
          file.path.split('.').last;
      storageReference.child(storagePath).putFile(file);
      return storagePath;
    } on Exception catch (e) {
      print('Saving file error : $e');
      return null;
    }
  }

  Future<dynamic> getImage(String path) {
    try {
      StorageReference storageReference = firebaseStorage.ref().child(path);
      return storageReference.getDownloadURL();
    } on Exception catch (e) {
      print('$e');
    }
    return null;
  }
}
