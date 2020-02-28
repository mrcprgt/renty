import 'package:renty_crud_version/constants/route_names.dart';
import 'package:renty_crud_version/models/item.dart';
import 'package:renty_crud_version/services/navigation_service.dart';
import 'package:renty_crud_version/viewmodels/base_model.dart';

import '../locator.dart';

class ItemDetailViewModel extends BaseModel {
  NavigationService _navigationService = locator<NavigationService>();
  void goToTransactionView(Item item) {
    _navigationService.navigateTo(ItemTransactionViewRoute, arguments: item);
  }
}
