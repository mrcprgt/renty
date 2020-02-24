import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future initialise() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(
      //app is on foreground, receive push notif
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      //called when app is fully closed, and opened from notif.
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      //app is on backgorund / minimized.
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }
}
