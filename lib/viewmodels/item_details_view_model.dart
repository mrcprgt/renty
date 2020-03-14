import 'package:renty_crud_version/constants/route_names.dart';
import 'package:renty_crud_version/models/item.dart';
import 'package:renty_crud_version/services/navigation_service.dart';
import 'package:renty_crud_version/viewmodels/base_model.dart';

import '../locator.dart';

class TransactionArguments {
  Item item;
  var rentChosen;
  DateTime startRentDate;
  DateTime endRentDate;

  TransactionArguments({
    this.item,
    this.rentChosen,
    this.startRentDate,
    this.endRentDate,
  });
}

class ItemDetailViewModel extends BaseModel {
  NavigationService _navigationService = locator<NavigationService>();
  void goToTransactionView(
    var receivedItem,
    var receivedRentChosen,
    var receivedStartRentDate,
    var receivedEndRentDate,
  ) {
    TransactionArguments transacArgu = new TransactionArguments(
      item: receivedItem,
      rentChosen: receivedRentChosen,
      startRentDate: receivedStartRentDate,
      endRentDate: receivedEndRentDate,
    );

    //print(transacArgu.rentChosen);
    _navigationService.navigateTo(ItemTransactionViewRoute,
        arguments: transacArgu);
  }
}
