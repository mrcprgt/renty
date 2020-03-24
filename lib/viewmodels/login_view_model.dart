import 'package:flutter/foundation.dart';
import 'package:renty_crud_version/constants/route_names.dart';
import 'package:renty_crud_version/services/authentication_service.dart';
import 'package:renty_crud_version/services/dialog_service.dart';
import 'package:renty_crud_version/services/navigation_service.dart';

import '../locator.dart';
import 'base_model.dart';

class LoginViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future logInWithEmail(String email, String password) async {
    setBusy(true);

    var result = await _authenticationService.loginWithEmail(
        email: email, password: password);

    setBusy(false);

    if (result is bool) {
      if (result) {
        _navigationService.navigateTo(HomeTabViewRoute);
      } else {
        await _dialogService.showDialog(
            title: 'Oops! Something went wrong',
            description:
                'Try checking your information if there was anything wrong!');
      }
    } else {
      await _dialogService.showDialog(
          //TODO: Spice up error messages!
          title: 'Login In Failure',
          description: result);
    }
  }

  Future signUpWithEmail(String email, String password, String fullName) async {
    setBusy(true);

    var result = await _authenticationService.signUpWithEmail(
        email: email, password: password, fullName: fullName);

    setBusy(false);

    if (result is bool) {
      if (result) {
        _navigationService.navigateTo(HomeTabViewRoute);
      } else {
        await _dialogService.showDialog(
            title: 'Oops! Something went wrong',
            description:
                'Try checking your information if there was anything wrong!');
      }
    } else {
      await _dialogService.showDialog(
          //TODO: Spice up error messages!
          title: 'Sign Up Failure',
          description: 'A network error occured. Please try again.');
    }
  }

  Future signInWithGoogle() async {
    setBusy(true);
    await _authenticationService
        .loginWithGoogle()
        .whenComplete(() => {_navigationService.navigateTo(HomeTabViewRoute)});
    setBusy(false);
  }
}
