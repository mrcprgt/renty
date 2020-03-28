import 'package:flutter/material.dart';
import 'package:renty_crud_version/constants/route_names.dart';
import 'package:renty_crud_version/services/authentication_service.dart';
import 'package:renty_crud_version/services/navigation_service.dart';
import 'package:renty_crud_version/ui/views/login_view.dart';
import 'package:renty_crud_version/viewmodels/base_model.dart';

import '../locator.dart';

class AccountsViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future logOut() async {
    await _authenticationService
        .logOut()
        .whenComplete(() => {_navigationService.navigateTo(LoginViewRoute)});
  }

  List getUserDetails() {
    var fullName = _authenticationService.currentUser.fullName;
    var emailAddress = _authenticationService.currentUser.email;
    var isVerified = _authenticationService.currentUser.isVerifiedUser;

    var userDetailsMap = [fullName, emailAddress, isVerified];
    return userDetailsMap;
  }

  void goToVerification() {
    _navigationService.navigateTo(VerificationViewRoute);
  }
}
