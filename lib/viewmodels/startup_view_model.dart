import 'package:renty_crud_version/constants/route_names.dart';
import 'package:renty_crud_version/services/authentication_service.dart';
import 'package:renty_crud_version/services/navigation_service.dart';
import 'package:renty_crud_version/services/push_notification_service.dart';
import 'package:renty_crud_version/viewmodels/base_model.dart';

import '../locator.dart';

class StartUpViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final PushNotificationService _pushNotificationService =
      locator<PushNotificationService>();

  Future handleStartUpLogic() async {
    //Initialize push notif service.
    await _pushNotificationService.initialise();

    //Check if user is logged in.
    var hasLoggedInUser = await _authenticationService.isUserLoggedIn();
    //print('Is a user logged in? :' + hasLoggedInUser.toString());
    if (hasLoggedInUser) {
      _navigationService.navigateTo(HomeTabViewRoute);
    } else {
      _navigationService.navigateTo(LoginViewRoute);
    }
  }
}
