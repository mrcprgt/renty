import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:renty_crud_version/models/item.dart';
import 'package:renty_crud_version/models/operations.dart';
import 'package:renty_crud_version/models/user.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection('users');

  final CollectionReference _itemListingsCollectionReference =
      Firestore.instance.collection('items');

  final CollectionReference _operationsCollectionReference =
      Firestore.instance.collection("operations");

  final CollectionReference _rentalsCollectionReference =
      Firestore.instance.collection("rentals");

  FirebaseMessaging _fcm = FirebaseMessaging();

  final StreamController<List<Item>> _itemListingController =
      StreamController<List<Item>>.broadcast();

  //make user
  Future createUser(User user) async {
    try {
      await _usersCollectionReference.document(user.id).setData({
        'id': user.id,
        'acc_created': DateTime.now(),
        'email': user.email,
        'full_name': user.fullName,
        'address': user.address,
        'birth_date': user.birthDate,
        'contact_number': user.contactNumber,
        'is_verified': false,
      });
    } catch (e) {
      if (e is PlatformException) return e.message;
    }
  }

  //Get user
  Future getUser(String uid) async {
    Logger logger = Logger();
    logger.d("running getUserFunction");
    try {
      var userData = await _usersCollectionReference.document(uid).get();
      print(User.fromData(userData.data));
      return User.fromData(userData.data);
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }
      logger.e(e.toString());
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

        //TODO: Sort by date.

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

  Future<void> submitRentingApplication(
    Item item,
    var renterID,
    Map rentDuration,
    var rentChosenValue,
    var serviceFeePayable,
    var totalPayable,
  ) async {
    var renterFCMToken = await _fcm.getToken();
    DocumentReference docRef = await _rentalsCollectionReference.add({
      'item_ID': item.id,
      'lender_ID': item.ownerID,
      'lender_fcm_token': item.ownerFCM,
      'lender_def_price': rentChosenValue,
      'rent_duration': rentDuration,
      'renter_ID': renterID,
      'renter_fcm_token': renterFCMToken,
      'service_fee': serviceFeePayable,
      'total_price': totalPayable,
      'status': null,
    });
  }

  //EOF
}
