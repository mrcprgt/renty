import 'package:flutter/services.dart';
import 'package:renty_crud_version/constants/route_names.dart';
import 'package:renty_crud_version/models/operations.dart';
import 'package:renty_crud_version/models/item.dart';

import 'package:renty_crud_version/services/firestore_service.dart';
import 'package:renty_crud_version/services/navigation_service.dart';

import '../locator.dart';
import 'base_model.dart';

class HomeViewModel extends BaseModel {
  HomeViewModel() {
    fetchOperations();
  }
  // final AuthenticationService _authenticationService =
  //     locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  //final DialogService _dialogService = locator<DialogService>();

  List<Item> _items;
  List<Item> get items => _items;

  Operations _operations;
  Operations get operations => _operations;

  // List<String> categories = operations.categoriesMap.toList();

  void listenToItemListings() {
    setBusy(true);
    //print('Item list: ' + items.toString());
    _firestoreService.listenToItemRealTime().listen((itemListingsData) {
      List<Item> updatedItemListing = itemListingsData;
      if (updatedItemListing != null && updatedItemListing.length > 0) {
        _items = updatedItemListing;
        notifyListeners();
      } else {
        print('No stream received');
      }

      setBusy(false);
    });
  }

  Future fetchOperations() async {
    //TODO: FIX CATEGORIES ASAP
    try {
      Operations operationsResults = await _firestoreService.getOperationsFromDb();
          await _firestoreService.getOperationsFromDb().then((val) {
        //print('val categ: ' + val.categoriesMap);
        return val;
      });

      //print('oper res ' + operationsResults.toString());
      if (operationsResults.categoriesMap == null) {
        print('oper?null');
      } else {
        //print('oper has val');
        print(operationsResults.serviceFee.toString());
        _operations = operationsResults;
      }
    } catch (e) {
      if (e is PlatformException) {
        return e.toString();
      }
    }

    return;
  }

  void goToItemDetailPage(Item item) {
    print(item.itemName + ' is being routed ...');
    _navigationService.navigateTo(ItemDetailViewRoute, arguments: item);
  }

  void goToItemLendPage() {
    _navigationService.navigateTo(ItemLendViewRoute);
  }
}
