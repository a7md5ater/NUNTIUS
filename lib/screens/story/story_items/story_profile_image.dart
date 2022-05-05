import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../models/UserModel.dart';
import '../../../styles/icons_broken.dart';

class StoryProfileImage extends StatelessWidget {
  //final UserModel userModel;
  const StoryProfileImage({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // if(userModel.image==""){
    //   return SizedBox(
    //       width: 13.w,height: 6.5.h,
    //       child: Icon(IconBroken.Profile,color: MyColors.blue,size: 25.sp,));
    // }else{
      return SizedBox(
        width: 14.2.w,height: 7.2.h,
        child: CircleAvatar(
          radius: 22.sp,
          backgroundColor: MyColors.blue,
          child: CircleAvatar(
            radius: 20.sp,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            child: CircleAvatar(
              radius: 19.sp,
              backgroundColor: MyColors.blue.withOpacity(0.2),
              backgroundImage: const CachedNetworkImageProvider(
                  "https://firebasestorage.googleapis.com/v0/b/chat-2a648.appspot.com/o/profile_image%2Fimage_picker5186024229784652846.jpg?alt=media&token=1e04fa29-d200-4d8a-a943-cc0992036374"
              ),
            ),
          ),
        ),
      );
    //}
  }
}