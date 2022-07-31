import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/cubit/app/app_states.dart';
import 'package:chat/screens/call_content/call_content_items/call_content_calling.dart';
import 'package:chat/screens/call_content/call_content_items/call_content_friends_name.dart';
import 'package:chat/screens/call_content/call_content_items/call_content_profile_image.dart';
import 'package:chat/screens/call_content/call_content_items/call_content_time.dart';
import 'package:chat/services/agora/agora_server.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

/// Define App ID and Token

class VoiceCallContentScreen extends StatefulWidget {
  final String senderID;
  final String friendName;
  final String callID;
  final String token;
  final String channelName;
  const VoiceCallContentScreen(
      {Key? key,
      required this.senderID,
      required this.token,
      required this.channelName,
      required this.callID,
      required this.friendName})
      : super(key: key);

  @override
  State<VoiceCallContentScreen> createState() => _VoiceCallContentScreenState();
}

class _VoiceCallContentScreenState extends State<VoiceCallContentScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  late int _remoteUid = 0;
  late RtcEngine _engine;
  bool joined = false;

  @override
  void initState() {
    if (widget.senderID == uId) {
      playRingtone();
    } else {
      AppCubit.get(context).updateCallData(
        callID: widget.callID,
        friendID: widget.senderID,
        myCallStatus: "incoming",
        friendCallStatus: "outcoming",
      );
    }
    initAgora();
    super.initState();
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void playRingtone() async {
    await _audioPlayer.play(AssetSource('sounds/sender-ringtone.ogg'));
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  Future<void> initAgora() async {
    await [Permission.microphone, Permission.camera].request();
    _engine = await RtcEngine.create(AgoraServer.appId);
    _engine.enableVideo();
    // _engine.enableAudio();
    _engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          // setState(() => joined = true);
          debugPrint("‘local user $uid joined successfully’");
        },
        userJoined: (int uid, int elapsed) {
          debugPrint("‘remote user $uid joined successfully’");
          if (widget.senderID == uId) {
            _audioPlayer.stop();
          }
          setState(() => _remoteUid = uid);
        },
        userOffline: (int uid, UserOfflineReason reason) {
          AppCubit.get(context).getCallsData();
          debugPrint("‘remote user $uid left call’");
          setState(() => _remoteUid = 0);
          Navigator.of(context).pop(true);
        },
      ),
    );
    await _engine.joinChannel(
        widget.token, widget.channelName, null, widget.senderID == uId ? 0 : 1);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppUpdateInCallStatusFalseState) {
          Get.back();
        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return SafeArea(
          child: Scaffold(
            body: Padding(
              padding: EdgeInsets.all(20.sp),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CallContentProfileImage(image: cubit.userModel!.image!),
                    SizedBox(
                      height: 5.h,
                    ),
                    CallContentFriendName(name: widget.friendName),
                    SizedBox(
                      height: 1.h,
                    ),
                    if (widget.senderID == uId && _remoteUid == 0)
                      const CallContentCalling()
                    else
                      const CallContentTime()
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                cubit.updateInCallStatus(isTrue: false);
              },
              backgroundColor: Colors.red,
              child: const Icon(
                IconBroken.Call,
                color: Colors.white,
              ),
            ),
            // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          ),
        );
      },
    );
  }
}
