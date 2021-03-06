import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:renty_crud_version/debug/logger.dart';
import 'package:renty_crud_version/models/item.dart';
import 'package:renty_crud_version/models/user.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection('users');

  final CollectionReference _itemListingsCollectionReference =
      Firestore.instance.collection('items');

  final CollectionReference _rentalsCollectionReference =
      Firestore.instance.collection("rentals");

  FirebaseMessaging _fcm = FirebaseMessaging();

  final StreamController<List<Item>> _itemListingController =
      StreamController<List<Item>>.broadcast();

  final log = getLogger("Firestore Service");

  //For realtime lazy load
  DocumentSnapshot _lastDocument;
  List<List<Item>> _allPagedResults = List<List<Item>>();
  bool _hasMorePosts = true;

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
    log.d("running getUserFunction");
    try {
      var userData = await _usersCollectionReference.document(uid).get();
      log.d("Document Snapshot: " + userData.data.toString());
      log.d("User from Data Result: " + User.fromData(userData.data).fullName);
      return User.fromData(userData.data);
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }
      log.e(e.toString());
    }
  }

  //cancel streaming subscription
  void cancelSubscription() {
    _itemListingController.close();
  }

  //Streaming assets to grid view
  Stream listenToItemRealTime() {
    _requestItems();
    return _itemListingController.stream;
  }

  void _requestItems() {
    log.d("Requesting more items");
    // #2: split the query from the actual subscription
    var pageItemsQuery = _itemListingsCollectionReference
        .orderBy('date_entered', descending: true)
        // #3: Limit the amount of results
        .limit(20);

    if (_lastDocument != null) {
      pageItemsQuery = pageItemsQuery.startAfterDocument(_lastDocument);
    }

    // If there's no more posts then bail out of the function
    if (!_hasMorePosts) return;

    var currentRequestIndex = _allPagedResults.length;

    pageItemsQuery.snapshots().listen((postsSnapshot) {
      if (postsSnapshot.documents.isNotEmpty) {
        var posts = postsSnapshot.documents
            .map((snapshot) => Item.fromMap(snapshot.data, snapshot.documentID))
            .where((mappedItem) =>
                mappedItem.itemName != null && mappedItem.isApproved)
            .toList();

        // Check if the page exists or not
        var pageExists = currentRequestIndex < _allPagedResults.length;

        // If the page exists update the posts for that page
        if (pageExists) {
          _allPagedResults[currentRequestIndex] = posts;
        }
        // If the page doesn't exist add the page data
        else {
          _allPagedResults.add(posts);
        }

        // Concatenate the full list to be shown
        var allPosts = _allPagedResults.fold<List<Item>>(List<Item>(),
            (initialValue, pageItems) => initialValue..addAll(pageItems));

        //  Broadcase all posts
        _itemListingController.add(allPosts);

        // Save the last document from the results only if it's the current last page
        if (currentRequestIndex == _allPagedResults.length - 1) {
          _lastDocument = postsSnapshot.documents.last;
        }

        // Determine if there's more posts to request
        _hasMorePosts = posts.length == 20;
      }
    });
    // // Register the handler for when the posts data changes
    // _itemListingsCollectionReference.snapshots().listen((itemListSnapshot) {
    //   //check if document is not empty
    //   if (itemListSnapshot.documents.isNotEmpty) {
    //     //assign the snapshot to a variable and convert data to Map. Check if approved.
    //     var items = itemListSnapshot.documents
    //         .map((snapshot) => Item.fromMap(snapshot.data, snapshot.documentID))
    //         .where((mappedItem) =>
    //             mappedItem.itemName != null && mappedItem.isApproved)
    //         .toList();

    //     // Add the posts onto the controller
    //     _itemListingController.add(items);
    //   }
    // });
  }

  void requestMoreData() => _requestItems();

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
      log.d(toAdd.toString());
      imgUrls.add(toAdd.toString());
    }

    // return await (await uploadTask.onComplete).ref.getDownloadURL();

    return imgUrls;
  }

  //List an item for rent
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

  //Submit a Renting application
  Future<void> submitRentingApplication(
    Item item,
    var renterID,
    Map rentDuration,
    var rentChosenValue,
    var serviceFeePayable,
    var totalPayable,
  ) async {
    var renterFCMToken = await _fcm.getToken();
    await _rentalsCollectionReference.add({
      'date_entered': DateTime.now(),
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

    _usersCollectionReference
        .document(renterID)
        .collection('transactions')
        .add({'item_id': item.id, 'status': null});
  }

  Future<void> updateAccountDetails(
    String uid,
    String gender,
    DateTime birthDate,
    String contactNumber,
    Map address,
  ) async {
    try {
      await _usersCollectionReference.document(uid).updateData({
        "phone": contactNumber,
        "b_date": birthDate,
        "address": address,
      });
    } catch (e) {
      if (e is PlatformException) {
        print(e.message);
      }
    }
  }

  //EOF
}
