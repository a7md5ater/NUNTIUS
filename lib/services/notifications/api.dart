import 'package:dio/dio.dart';

import '../../shared/constants.dart';

class DioHelper {
  static Dio? dio;

  static init() {
    dio = Dio(
      BaseOptions(
          baseUrl: 'https://fcm.googleapis.com/fcm/send',
          receiveDataWhenStatusError: true,
          headers: {
            'Content-Type': "application/json",
            'Authorization':
                'key=AAAAaTTvvMM:APA91bFmi2dEmGM-PWzfBvG3IkR3BhNo-lDDXKE3UrIiSDuNJhUHyAhhwGf8cOpdCudUUh5YtScb39zJrA-2mlsOcszkqX66-CZmy02RaJ1d_QuEXM8u__gBQcII7yOZs0alrHvRf8T_',
          }),
    );
  }

  static Future<Response> pushNotification(
      {required String token,
      required String myPhoneNumber,
      required String userID,
      required String userName}) {
    Map<String, dynamic> data = {
      "to": token,
      "priority": "high",
      "notification": {
        "title": "New Message",
        "body": "$userName sent you new message",
        "sound": "default"
      },
      "data": {
        "type": "message",
        "id": "$uId$userID${DateTime.now().millisecondsSinceEpoch}",
        "senderID": "$uId",
        "phoneNumber": myPhoneNumber,
        "click_action": "FLUTTER_NOTIFICATION_CLICK"
      }
    };

    return dio!.post('', data: data);
  }

  static Future<Response> pushCallNotification({
    required String userToken,
    required String channelToken,
    required String myPhoneNumber,
    required String receiverID,
    required String callID,
    required String callType,
  }) {
    Map<String, dynamic> data = {
      "to": userToken,
      "priority": "high",
      "data": {
        "type": callType,
        "callID": callID,
        "token": channelToken,
        "channelName": "$uId$receiverID$callType",
        "senderID": "$uId",
        "phoneNumber": myPhoneNumber,
        "click_action": "FLUTTER_NOTIFICATION_CLICK"
      }
    };

    return dio!.post('', data: data);
  }
}
