import 'package:chat/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;

class MyView extends StatelessWidget {
  const MyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.sp),
      child: Container(
        width: 28.w,
        height: 22.h,
        color: MyColors.blue,
        child: const RtcLocalView.SurfaceView(),
      ),
    );
  }
}
