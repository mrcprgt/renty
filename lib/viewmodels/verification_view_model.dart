import 'package:renty_crud_version/constants/route_names.dart';
import 'package:renty_crud_version/services/authentication_service.dart';
import 'package:renty_crud_version/services/firestore_service.dart';
import 'package:renty_crud_version/services/navigation_service.dart';
import 'package:renty_crud_version/viewmodels/base_model.dart';

import '../locator.dart';

class VerificationViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();

  Future submitAccountVerification(
    String gender,
    DateTime birthDate,
    String contactNumber,
    String addressName,
    String floorUnitNumber,
    String cityMunicipality,
    String streetBarangay,
    String additionalNotes,
  ) async {
    Map address = {
      "address_name": addressName,
      "city_munici": cityMunicipality,
      "unit_num": floorUnitNumber,
      "street_barangay": streetBarangay,
      "additional_notes": additionalNotes
    };
    var uid = await _authenticationService.getUserDetails();
    await _firestoreService.updateAccountDetails(
        uid, gender, birthDate, contactNumber, address);

    print("done");
    _navigationService.navigateTo(HomeTabViewRoute);
    notifyListeners();
  }
}
