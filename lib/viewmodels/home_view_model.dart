import 'package:renty_crud_version/constants/route_names.dart';
import 'package:renty_crud_version/models/operations.dart';
import 'package:renty_crud_version/models/item.dart';

import 'package:renty_crud_version/services/firestore_service.dart';
import 'package:renty_crud_version/services/navigation_service.dart';

import '../locator.dart';
import 'base_model.dart';

class HomeViewModel extends BaseModel {
  // final AuthenticationService _authenticationService =
  //     locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  //final DialogService _dialogService = locator<DialogService>();

  List<Item> _items;
  List<Item> get items => _items;

  void listenToItemListings() {
    setBusy(true);
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

  void requestMoreData() => _firestoreService.requestMoreData();

  List<String> getAllItemNames() {
    List<String> itemNamesList = [];
    for (var e in items) {
      itemNamesList.add(e.itemName.toLowerCase());
    }
    return itemNamesList;
  }

  Future searchOptions(String pattern) async {
    var allItemsList = getAllItemNames();
    List<dynamic> suggestionsList = [];
    pattern = pattern.toLowerCase();
    for (var i in allItemsList) {
      if (i.contains(pattern)) {
        suggestionsList.add(i);
      }
    }
    return suggestionsList;
  }

  void goToItemDetailPage(Item item) {
    print(item.itemName + ' is being routed ...');
    _navigationService.navigateTo(ItemDetailViewRoute, arguments: item);
  }

  void goToItemLendPage() {
    _navigationService.navigateTo(ItemLendViewRoute);
  }
}
