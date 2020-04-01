import 'package:get_it/get_it.dart';
import 'package:renty_crud_version/services/authentication_service.dart';
import 'package:renty_crud_version/services/firestore_service.dart';

import 'package:renty_crud_version/services/navigation_service.dart';
import 'package:renty_crud_version/services/dialog_service.dart';
import 'package:renty_crud_version/services/push_notification_service.dart';
import 'package:renty_crud_version/viewmodels/home_view_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => FirestoreService());
  locator.registerLazySingleton(() => PushNotificationService());

  locator.registerLazySingleton(() => HomeViewModel());
}
