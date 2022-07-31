import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/models/UserModel.dart';
import 'package:chat/screens/call_content/video_call/video_call_content_screen.dart';
import 'package:chat/services/agora/agora_server.dart';
import 'package:chat/shared/colors.dart';
import 'package:chat/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CallButton extends StatelessWidget {
  final UserModel user;
  final String type;
  final IconData icon;
  const CallButton(
      {Key? key, required this.user, required this.type, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          AgoraServer.getToken(
            receiverId: user.uId!,
            callType: type,
          ).then((value) {
            Get.to(
              () => VideoCallContentScreen(
                senderID: uId!,
                friendImage: user.image!,
                friendName: user.name!,
                token: value.data['token'],
                channelName: "$uId${user.uId}$type",
              ),
            );
          }).catchError((error) {
            printError("getToken", error.toString());
          });

          // AppCubit.get(context)
          //     .updateInCallStatus(isTrue: true, isOpening: true);
          // AppCubit.get(context).generateChannelToken(
          //   receiverId: user.uId!,
          //   friendPhone: user.phone!,
          //   callType: type,
          //   myCallStatus: "no response",
          //   friendCallStatus: "missed",
          //   userToken: user.token!,
          // );
        },
        icon: Icon(
          icon,
          color: MyColors.blue,
          size: 18.sp,
        ));
  }
}
