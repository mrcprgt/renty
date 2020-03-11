import 'package:renty_crud_version/constants/route_names.dart';
import 'package:renty_crud_version/models/item.dart';
import 'package:renty_crud_version/services/navigation_service.dart';
import 'package:renty_crud_version/viewmodels/base_model.dart';

import '../locator.dart';

class TransactionArguments {
  var item;
  var rentChosen;
  var startTime;
  var endTime;
  var startDate;
  var endDate;

  TransactionArguments(
      {this.item,
      this.rentChosen,
      this.startDate,
      this.endDate,
      this.startTime,
      this.endTime});
}

class ItemDetailViewModel extends BaseModel {
  NavigationService _navigationService = locator<NavigationService>();
  void goToTransactionView(
      var receivedItem,
      var receivedRentChosen,
      var receivedStartTime,
      var receivedEndTime,
      var receivedStartDate,
      var receivedEndDate) {
    TransactionArguments transacArgu = new TransactionArguments(
      item: receivedItem,
      rentChosen: receivedRentChosen,
      startDate: receivedStartDate,
      endDate: receivedEndDate,
      startTime: receivedStartTime,
      endTime: receivedEndTime,
    );

    print(transacArgu.rentChosen);
    _navigationService.navigateTo(ItemTransactionViewRoute,
        arguments: transacArgu);
  }
}
