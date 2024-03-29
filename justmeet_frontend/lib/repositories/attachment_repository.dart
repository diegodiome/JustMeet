
import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';

class AttachmentRepository {

  FirebaseStorage firebaseStorage;

  AttachmentRepository(this.firebaseStorage);

  Future<String> uploadImage(File file) async {
    try {
      StorageReference storageReference = firebaseStorage.ref();
      String storagePath = '/events_images/' +
          Random().nextInt(10000).toString() +
          '.' +
          file.path.split('.').last;
      storageReference.child(storagePath).putFile(file);
      return 'gs://justmeet-538b1.appspot.com/' + storagePath;
    } on Exception catch (e) {
      print('Saving file error : $e');
      return '';
    }
  }

  Future<String> uploadUserImage(File file) async {
    try {
      StorageReference storageReference = firebaseStorage.ref();
      String storagePath = '/user_images/' +
          Random().nextInt(10000).toString() +
          '.' +
          file.path.split('.').last;
      storageReference.child(storagePath).putFile(file);
      return 'gs://justmeet-538b1.appspot.com/' + storagePath;
    } on Exception catch (e) {
      print('Saving file error : $e');
      return '';
    }
  }

}