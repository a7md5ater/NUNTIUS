import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/cubit/app/app_states.dart';
import 'package:chat/screens/messages/messages_items/my_message.dart';
import 'package:chat/shared/colors.dart';
import 'package:chat/shared/default_widgets.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'messages_items/friend_message.dart';
import 'messages_items/message_filed.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {

  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state){
        AppCubit cubit = AppCubit.get(context);
        return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 10.h,
                backgroundColor: MyColors.darkBlack,
                centerTitle: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.sp),
                      bottomRight: Radius.circular(20.sp),
                    )
                ),
                title: Text(
                  "Ahmed Khater",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 17.sp
                  ),
                ),
                leading: const DefaultBackButton(),
                actions: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    child: IconButton(
                        onPressed: (){
                          //cubit.getContacts();
                        },
                        icon: Icon(IconBroken.Call,color: MyColors.blue,size: 20.sp,)
                    ),
                  )
                ],
              ),
              body: ResponsiveSizer(
                builder: (BuildContext context, Orientation orientation, ScreenType screenType) {
                  if(screenType.name=="mobile") {
                    return Column(
                      children: [
                        Expanded(
                          child: Column(
                            children: const [
                              MyMessage(),
                              FriendMessage(),
                            ],
                          ),
                        ),
                        SendMessageTextFiled(controller: _messageController)
                      ],
                    );
                  } else {
                    return Column(
                      children: const [
                        TabletMyMessage(),
                        TabletFriendMessage()
                      ],
                    );
                  }
                },
              ),
            )
        );
      },
    );
  }
}