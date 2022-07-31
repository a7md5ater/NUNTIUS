import 'package:chat/shared/colors.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class VideoBackButton extends StatelessWidget {
  const VideoBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Container(
          decoration: const BoxDecoration(
            color: MyColors.lightBlack,
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(10.sp).add(EdgeInsets.only(right: 1.sp)),
          child: Icon(
            IconBroken.Arrow___Left_2,
            size: 16.sp,
            // color: MyColors.black,
          )),
    );
  }
}
