import 'package:chat/models/StoryModel.dart';
import 'package:chat/screens/story/story_items/story_date.dart';
import 'package:chat/screens/story/story_items/story_profile_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../cubit/app/app_cubit.dart';
import '../../../shared/constants.dart';
import '../../story_view/story_view_screen.dart';

class ContactStory extends StatelessWidget {
  final String name;
  final String image;
  final String storyDate;
  final String userID;
  const ContactStory({Key? key, required this.image, required this.storyDate,
    required this.name, required this.userID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('stories')
        .doc(userID).collection('currentStories').orderBy("date").snapshots(),
      builder: (context, snapshot) {
        List<StoryModel> stories = [];
        if(snapshot.hasData){
          for (var element in snapshot.data!.docs) {
            StoryModel storyModel = StoryModel.fromJson(element.data());
            stories.add(storyModel);
          }
        }
        return GestureDetector(
          onTap: stories.isNotEmpty?(){
              AppCubit.get(context).zeroStoryIndex();
              Get.to(()=>StoryViewScreen(
                stories: stories,
                profileImage: image,
                name: "My Story",
                userID: uId!,
                storyID: null,
              ));
          }:null,
          child: Container(
            color: Colors.transparent,
            child: Row(
              children: [
                StoryProfileImage(image: image),
                SizedBox(
                  width: 4.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 13.sp),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 0.5.h,
                    ),
                    StoryDate(storyDate: storyDate,),
                  ],
                )
              ],
            ),
          ),
        );
      }
    );
  }
}