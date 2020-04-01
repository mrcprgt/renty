import 'package:renty_crud_version/constants/route_names.dart';
import 'package:renty_crud_version/debug/logger.dart';
import 'package:renty_crud_version/models/item.dart';
import 'package:renty_crud_version/services/authentication_service.dart';

import 'package:renty_crud_version/services/firestore_service.dart';
import 'package:renty_crud_version/services/navigation_service.dart';

import '../locator.dart';
import 'base_model.dart';

class HomeViewModel extends BaseModel {
  @override
  void dispose() {
    locator<FirestoreService>().cancelSubscription();
    super.dispose();
  }

  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  List<Item> _items;
  List<Item> get items => _items;

  //Debug
  final log = getLogger('HomeViewModel');

  void listenToItemListings() {
    log.d("starting listen to item listings");
    setBusy(true);
    //Listen to realtime stream
    _firestoreService.listenToItemRealTime().listen((itemListingsData) {
      //This variable will hold the items that we get from stream
      List<Item> updatedItemListing = itemListingsData;
      if (updatedItemListing != null && updatedItemListing.length > 0) {
        _items = updatedItemListing;
        notifyListeners();
      }
      setBusy(false);
    });
  }

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

  Future logout() async {
    await _authenticationService.logOut();
  }

  void requestMoreData() => _firestoreService.requestMoreData();
}
