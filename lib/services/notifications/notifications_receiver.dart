import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/models/UserModel.dart';
import 'package:chat/screens/messages/messages_screen.dart';
import 'package:chat/screens/receive_calls/receive_calls_screen.dart';
import 'package:chat/services/notifications/local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class NotificationsReceiver {
  static void handelForegroundMessage({required AppCubit cubit}) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      if (message.notification != null) {
        debugPrint(
            'Message also contained a notification: ${message.notification!.body}');
      }

      if (message.data['type'] != "message") {
        Get.to(() => ReceiveCallScreen(
              senderID: message.data['senderID'],
              senderPhone: message.data['phoneNumber'],
              token: message.data['token'],
              channelName: message.data['channelName'],
              callID: message.data['callID'],
              callType: message.data['type'],
            ));
      } else {
        UserModel? userModel = cubit.users.firstWhereOrNull(
            (element) => element.uId == message.data['senderID']);
        String? name =
            userModel != null ? userModel.name! : message.data['phoneNumber'];
        int id = (DateTime.now().millisecondsSinceEpoch / 1000).floor();
        debugPrint("current=================>${cubit.currentChat}");
        debugPrint("sender=================>${message.data['senderID']}");
        if (cubit.currentChat != message.data['senderID']) {
          NotificationsHelper.showNotification(
              id: id, name: name!, senderID: message.data['senderID']);
          cubit.receiveMessage();
        } else {
          cubit.receiveMessage();
        }
      }
    });
  }

  static void handelBackgroundMessage({required AppCubit cubit}) {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint("sender=================>${message.data['senderID']}");
      UserModel? userModel = cubit.chats.firstWhereOrNull(
          (element) => element.uId == message.data['senderID']);
      if (userModel == null) {
        cubit.getChats();
        userModel = cubit.chats.firstWhereOrNull(
            (element) => element.uId == message.data['senderID']);
        Get.to(() => MessagesScreen(user: userModel!, isFirstMessage: false));
      } else {
        Get.to(() => MessagesScreen(user: userModel!, isFirstMessage: false));
      }
    });
  }
}
