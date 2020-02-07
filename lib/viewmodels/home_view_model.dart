import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renty_crud_version/models/item.dart';

import 'package:renty_crud_version/services/authentication_service.dart';
import 'package:renty_crud_version/services/dialog_service.dart';
import 'package:renty_crud_version/services/firestore_service.dart';
import 'package:renty_crud_version/services/navigation_service.dart';

import '../locator.dart';
import 'base_model.dart';

class HomeViewModel extends BaseModel {
  final AuthenticationService _authenticationService = locator<AuthenticationService>();
  //final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  //final DialogService _dialogService = locator<DialogService>();

  List<Item> _items;
  List<Item> get items => _items;

  void listenToItemListings() {
    setBusy(true);
    print('Item list: ' + items.toString());
    _firestoreService.listenToItemRealTime().listen((itemListingsData) {
      List<Item> updatedItemListing = itemListingsData;
      if (updatedItemListing != null && updatedItemListing.length > 0) {
        _items = updatedItemListing;
        notifyListeners();
      }else{
        print('No stream received');
      }

      setBusy(false);
    });
  }

  // String getFirstName(){
  //   setBusy(true);

  //   var currentUser =  _authenticationService.getUserDetails();
  //   String firstName = ;

  // }
}
