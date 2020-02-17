import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class CloudStorageService {
  Future uploadImages(Asset asset) async {
    ByteData byteData = await asset.getByteData();
    List<int> imageData = byteData.buffer.asUint8List();
    StorageReference ref =
        FirebaseStorage.instance.ref().
        child("some_image_bame.jpg");
    StorageUploadTask uploadTask = ref.putData(imageData);

    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }
}
