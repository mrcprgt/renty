import 'package:flutter/material.dart';
import 'package:renty_crud_version/models/item.dart';
import 'package:renty_crud_version/services/authentication_service.dart';
import 'package:renty_crud_version/services/firestore_service.dart';
import 'package:renty_crud_version/services/navigation_service.dart';
import 'package:renty_crud_version/viewmodels/base_model.dart';

import '../locator.dart';

class ItemTransactionViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  Future submitApplicationRequest(
    Item item,
    DateTime startRentDate,
    DateTime endRentDate,
    var rentChosenValue,
    var serviceFeePayable,
    var totalPayable,
  ) async {
    Map rentDuration = {'start_date': startRentDate, 'end_date': endRentDate};
    var renterId = await _authenticationService.getUserDetails();
    _firestoreService.submitRentingApplication(item, renterId, rentDuration,
        rentChosenValue, serviceFeePayable, totalPayable);
  }
}
