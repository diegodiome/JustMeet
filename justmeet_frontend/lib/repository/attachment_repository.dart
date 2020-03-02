

import 'package:justmeet_frontend/cloud_storage.dart';

class AttachmentRepository {

  CloudStorage storage;

  AttachmentRepository(this.storage);

  Future<String> getStorageImageUrl(String imageUrl) async{
    String storageImageUrl;
    storageImageUrl = await storage.getImage(imageUrl);
    return storageImageUrl;
  }
}