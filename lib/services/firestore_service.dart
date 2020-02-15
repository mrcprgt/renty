import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:renty_crud_version/models/item.dart';
import 'package:renty_crud_version/models/operations.dart';
import 'package:renty_crud_version/models/user.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection('users');

  final CollectionReference _itemListingsCollectionReference =
      Firestore.instance.collection('item_listings');

  final CollectionReference _operationsCollectionReference =
      Firestore.instance.collection("operations");

  final StreamController<List<Item>> _itemListingController =
      StreamController<List<Item>>.broadcast();

  Future createUser(User user) async {
    try {
      await _usersCollectionReference.document(user.id).setData(user.toJson());
    } catch (e) {
      if (e is PlatformException) return e.message;
    }
  }

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

  //Streaming related
  Stream listenToItemRealTime() {
    // Register the handler for when the posts data changes
    _itemListingsCollectionReference.snapshots().listen((itemListSnapshot) {
      if (itemListSnapshot.documents.isNotEmpty) {
        var items = itemListSnapshot.documents
            .map((snapshot) => Item.fromMap(snapshot.data, snapshot.documentID))
            .where((mappedItem) => mappedItem.itemName != null)
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

        print('service catg map ' +
            operationsFromFirebase.categoriesMap.length.toString());
        print('service oper ' + operationsFromFirebase.serviceFee.toString());
        return operationsFromFirebase;
      } else {
        return operationsFromFirebase;
      }
    });
    return operationsFromFirebase;
  }

  //EOF
}
