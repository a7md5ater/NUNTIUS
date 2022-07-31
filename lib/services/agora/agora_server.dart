import 'package:chat/shared/constants.dart';
import 'package:dio/dio.dart';

class AgoraServer {
  static const String appId = "b54c7201e14d46c5876e4ab169ee1193";
  static Dio? dio;

  static init() {
    dio = Dio(
      BaseOptions(
          baseUrl: 'http://192.168.1.7:8082/',
          receiveDataWhenStatusError: true,
          connectTimeout: 20 * 1000,
          headers: {
            'Content-Type': "application/json",
          }),
    );
  }

  static Future<Response> getToken({
    required String receiverId,
    required String callType,
  }) {
    return dio!.post("fetch_rtc_token", data: {
      'channelName': "$uId$receiverId$callType",
    });
  }
}
