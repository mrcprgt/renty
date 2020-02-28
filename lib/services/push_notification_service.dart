import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:renty_crud_version/services/dialog_service.dart';

import '../locator.dart';
import 'firestore_service.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  DialogService dialogService = locator<DialogService>();

  Future initialise() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(
      //app is on foreground, receive push notif
      onMessage: (Map<String, dynamic> message) async {
        print('RECEIVIG NOTIF!');
        dialogService.showDialog(
          title: message['notification']['title'].toString(),
          description: message['notification']['body'].toString(),
        );
        print("onMessage: $message");
      },
      // onBackgroundMessage: (Map<String, dynamic> message) async {
      //   print("onBackground: $message");
      // },
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

  // Future<String> getUserToken() async {
  //   var userToken = await _fcm.getToken();
  //   return userToken;
  // }
}
