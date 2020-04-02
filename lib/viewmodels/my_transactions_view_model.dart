import 'package:renty_crud_version/debug/logger.dart';
import 'package:renty_crud_version/models/rental.dart';
import 'package:renty_crud_version/services/authentication_service.dart';
import 'package:renty_crud_version/services/firestore_service.dart';
import 'package:renty_crud_version/services/navigation_service.dart';

import '../locator.dart';
import 'base_model.dart';

class MyTransactionsViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();

  List<Rental> _rentals;
  List<Rental> get rentals => _rentals;

  //Debug
  final log = getLogger('MyTransactionsViewModel');

  void listenToItemListings() {
    log.d("starting listen to rentals listings");
    setBusy(true);
    //Listen to realtime stream
    _firestoreService
        .listenToTransactions(currentUser.id)
        .listen((itemListingsData) {
      //This variable will hold the items that we get from stream
      List<Rental> updatedItemListing = itemListingsData;
      if (updatedItemListing != null && updatedItemListing.length > 0) {
        _rentals = updatedItemListing;
        notifyListeners();
      }
      setBusy(false);
    });
  }

  Future getItemImgUrl(String uid) async {
    var data = await _firestoreService.crossReference(uid);
    return data;
  }
}
