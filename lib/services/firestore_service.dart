import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:renty_crud_version/locator.dart';
import 'package:renty_crud_version/models/item.dart';
import 'package:renty_crud_version/models/operations.dart';
import 'package:renty_crud_version/models/user.dart';
import 'package:renty_crud_version/services/push_notification_service.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection('users');

  final CollectionReference _itemListingsCollectionReference =
      Firestore.instance.collection('items');

  final CollectionReference _operationsCollectionReference =
      Firestore.instance.collection("operations");

  FirebaseMessaging _fcm = FirebaseMessaging();

  final StreamController<List<Item>> _itemListingController =
      StreamController<List<Item>>.broadcast();

  //make user
  Future createUser(User user) async {
    try {
      await _usersCollectionReference.document(user.id).setData(user.toJson());
    } catch (e) {
      if (e is PlatformException) return e.message;
    }
  }

  //Get user
  Future getUser(String uid) async {
    try {
      var userData = await _usersCollectionReference.document(uid).get();
      return User.fromData(userData.data);
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  //Streaming assets to grid view
  Stream listenToItemRealTime() {
    // Register the handler for when the posts data changes
    _itemListingsCollectionReference.snapshots().listen((itemListSnapshot) {
      if (itemListSnapshot.documents.isNotEmpty) {
        var items = itemListSnapshot.documents
            .map((snapshot) => Item.fromMap(snapshot.data, snapshot.documentID))
            .where((mappedItem) =>
                mappedItem.itemName != null && mappedItem.isApproved)
            .toList();

        // Add the posts onto the controller
        _itemListingController.add(items);
      }
    });

    return _itemListingController.stream;
  }

  Future<Operations> getOperationsFromDb() async {
    var documentRef = _operationsCollectionReference.document("items");
    Operations operationsFromFirebase = new Operations();
    documentRef.get().then((DocumentSnapshot ds) {
      if (ds.exists) {
        operationsFromFirebase.categoriesMap = ds.data['categories'];
        operationsFromFirebase.serviceFee = ds.data['service_fee_%'];

        // print('service catg map ' +
        //     operationsFromFirebase.categoriesMap.length.toString());
        // print('service oper ' + operationsFromFirebase.serviceFee.toString());
        return operationsFromFirebase;
      } else {
        return operationsFromFirebase;
      }
    });
    return operationsFromFirebase;
  }

  Future uploadImages(List<Asset> asset, String docRefId) async {
    List<dynamic> imgUrls = new List();
    for (int i = 0; i < asset.length; i++) {
      ByteData byteData = await asset[i].getByteData();
      List<int> imageData = byteData.buffer.asUint8List();
      StorageReference ref =
          FirebaseStorage.instance.ref().child("/item_img/$docRefId/$i.jpg");
      StorageUploadTask uploadTask = ref.putData(imageData);
      // var toAdd = await uploadTask.onComplete
      //   ..ref.getDownloadURL();
      var toAdd = await (await uploadTask.onComplete).ref.getDownloadURL();
      print(toAdd.toString());
      imgUrls.add(toAdd.toString());
    }

    // return await (await uploadTask.onComplete).ref.getDownloadURL();

    return imgUrls;
  }

  Future<void> submitLendingData(
      String formItemName,
      String formItemDescription,
      Map rentDetails,
      Map acquisitionMap,
      var owner,
      DateTime submissionDate,
      List<Asset> asset) async {
        var lenderToken = await _fcm.getToken();
    DocumentReference docRef = await _itemListingsCollectionReference.add({
      'item_name': formItemName,
      'item_description': formItemDescription,
      'rent_details': rentDetails,
      'acquisition_map': acquisitionMap,
      'lender': owner,
      'date_entered': submissionDate,
      'is_approved': false,
      'is_currently_rented': false,
      'lender_token': lenderToken,
    });
    print('doc id:' + docRef.documentID.toString());
    print('fcm token:' + lenderToken.toString());
    var imgRef = await uploadImages(asset, docRef.documentID);
    print('imgref: ' + imgRef.toString());
    await _itemListingsCollectionReference
        .document(docRef.documentID)
        .updateData({
      'pictures': imgRef,
    });
  }

  //EOF
}
