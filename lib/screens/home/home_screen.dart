import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/cubit/app/app_states.dart';
import 'package:chat/shared/colors.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state){
        AppCubit cubit = AppCubit.get(context);
        return SafeArea(
          child: Scaffold(
            body: cubit.screens[cubit.navBarIndex],
            extendBody: true,
            bottomNavigationBar: Padding(
              padding: EdgeInsets.only(bottom: 1.h),
              child: DotNavigationBar(
                curve: Curves.ease,
                currentIndex: cubit.navBarIndex,
                onTap: (index) {
                  cubit.changeNavBar(index);
                },
                marginR: EdgeInsets.symmetric(horizontal: 3.w),
                dotIndicatorColor: Colors.transparent,
                selectedItemColor: MyColors.blue,
                unselectedItemColor: MyColors.white.withOpacity(0.7),
                backgroundColor: MyColors.lightBlack,
                itemPadding: EdgeInsets.only(
                  left: 7.w,
                  right: 7.w,
                  top: 1.4.h,
                  bottom: 1.8.h,
                ),
                borderRadius: 50.sp,
                items: [
                  DotNavigationBarItem(
                    icon: Icon(IconBroken.Chat,size: 21.sp,),
                  ),
                  DotNavigationBarItem(
                    icon: Icon(IconBroken.Camera,size: 21.sp,),
                  ),
                  DotNavigationBarItem(
                    icon: Icon(IconBroken.Call,size: 21.sp,),
                  ),
                  DotNavigationBarItem(
                    icon: Icon(IconBroken.User1,size: 21.sp,),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

